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

  def mno_id(mno)
    if mno == "mtn"
      2
    elsif mno == "airtel"
      1
    elsif mno == "glo"
      3
    elsif mno == "9mobile"
      4
    else
      raise AirvendInvalidProvider, "Invalid Mobile Network Operator, mno can only be 'mtn', 'glo', 'airtel' or '9mobile'"
    end
  end

  def provider_id(mno)
    case mno
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
end
