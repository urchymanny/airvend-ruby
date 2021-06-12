require 'faraday'
require 'faraday/detailed_logger'
require 'typhoeus'
class Base
  def initialize(airvendObj)
    @airvendObj = airvendObj
  end

  def connect(api_hash)
    conn = Faraday.new(:url => @airvendObj.base_url, :headers => @airvendObj.headers(api_hash)) do |faraday|
      faraday.request  :url_encoded
      faraday.response :detailed_logger
      faraday.adapter  :typhoeus
    end
    return conn
  end


  def produce_error(response)
    status = response.status
    if status == 400
      raise AirvendBadRequestError, "There's something wrong with this request - #{response.status}"
    elsif status == 401
      raise AirvendUnauthorizedError, "You're not authorized to access this resource - #{response.status}"
    elsif status == 404
      raise AirvendNotFoundError, "The resource could not be found - #{response.status}"
    elsif status == 409
      raise AirvendConflictError, "The Reference you provided already exists, please use unique reference IDs for every transaction - #{response.status}"
    elsif status == 417
      raise AirvendIncorrectPayload, "Please confirm that your payload data is correct and standard - #{response.status}"
    elsif (400..451).member?(status)
      raise AirvendUnknownClientError, "Please send an email to hey@uche.io explaining how you got this error - #{response.status}"
    elsif (500..511).member?(status)
      raise AirvendServerError.new(response.body)
    end
  end

  def rename_hash(hash)
    hash.keys.each do |a|
      hash[underscorelize(a.to_s).to_sym] = hash.delete a
    end
    hash
  end

  def underscorelize(text)
    text.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def get_plans(provider, product_type)
    params_hash = { 'networkid'=> provider_id(provider), 'type'=> product_type }
		details = {}
		details.merge!({ 'details'=>params_hash })
		api_hash = @airvendObj.hash_req(details)
		begin
			response = productAdapter(api_hash, details)
		rescue
			return response
		else
      hash = rename_hash(JSON.parse(response.body, { symbolize_names: true }))
      details = rename_hash(hash[:details])
      details[:message].each do |d|
        rename_hash(d)
      end
      hash
		end
  end

  def verify_customer(product_type, account_id)
		params_hash = { 'type'=> product_type, 'account'=> account_id }
		details = {}
		details.merge!({ 'details'=>params_hash })
		api_hash = @airvendObj.hash_req(details)
		begin
			response = verifyAdapter(api_hash, details)
		rescue
			return response
		else
			if response.status == 200
        hash = rename_hash(JSON.parse(response.body, { symbolize_names: true }))
        rename_hash(hash[:details])
        hash
      else
        produce_error(response)
			end
		end
	end

  def mno_id(mno)
    case mno.downcase
    when "mtn"
      2
    when "airtel"
      1
    when "glo"
      3
    when "9mobile"
      4
    else
      raise AirvendInvalidProvider, "Invalid Mobile Network Operator, mno can only be 'mtn', 'glo', 'airtel' or '9mobile'"
    end
  end

  def provider_id(mno)
    case mno.downcase
    when "mtn"
      2
    when "airtel"
      1
    when "glo"
      3
    when "9mobile"
      4
    else
      raise AirvendInvalidProvider, "Invalid Mobile Network Operator, mno can only be 'mtn', 'glo', 'airtel' or '9mobile'"
    end
  end

  def power_id(account, account_type)
    x = account.upcase
    y = account_type.upcase
    if x == "IE"
      if y == "POSTPAID"
        return "10"
      elsif y == "PREPAID"
        return "11"
      end
    elsif x == "EKO"
      if y == "POSTPAID"
        return "13"
      elsif y == "PREPAID"
        return "14"
      end
    elsif x == "PHED"
      if y == "POSTPAID"
        return "15"
      elsif y == "PREPAID"
        return "16"
      end
    elsif x == "EEDC"
      if y == "POSTPAID"
        return "22"
      elsif y == "PREPAID"
        return "21"
      end
    elsif x == "KEDCO"
      return "20"
    elsif x == "AEDC"
      if y == "POSTPAID"
        return "25"
      elsif y == "PREPAID"
        return "24"
      end
    elsif x == "IBEDC"
      if y == "POSTPAID"
        return "12"
      elsif y == "PREPAID"
        return "11"
      end
    else
      raise AirvendInvalidProvider, "Invalid Power Provider, see documentation: https://github.com/urchymanny/airvend-ruby#electricity-vending"
    end
  end

  def tv_id(provider)
    case provider.downcase
    when "dstv"
      30
    when "gotv"
      40
    when "startimes"
      70
    else
      raise AirvendInvalidProvider, "Invalid Power Provider, see documentation: https://github.com/urchymanny/airvend-ruby#electricity-vending"
    end
  end
end
