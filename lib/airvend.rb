# frozen_string_literal: true

require_relative "airvend/version"
module Airvend
  attr_reader :public_key, :private_key

  class Vend
    def airtime(txref, phone, mno_id, amount)
      params_hash = { "ref" => txref, "account" => phone, "networkid" => mno_id, "type" => "1", "amount" => amount }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      resp = vendAdapter(api_hash, details)
      if resp.status == 200
        logResponse(resp)
        resp
      else
        raise "An error with this response code #{resp.status} has occurred. Response: #{resp.body}"
      end
    end

    def data(txref, phone, mno_id, amount)
      params_hash = { "ref" => txref, "account" => phone, "networkid" => mno_id, "type" => "2", "amount" => amount }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      resp = vendAdapter(api_hash, details)
      if resp.status == 200
        logResponse(resp)
        resp
      else
        raise "An error with this response code #{resp.status} has occurred. Response: #{resp.body}"
      end
    end

    def payTv(txref, account, provider_id, amount)
      customernumber = verify(provider_id, account)["customernumber"].to_s
      params_hash = { "ref" => txref, "account" => account, "type" => provider_id, "amount" => amount,
                      "customernumber" => customernumber, "invoicePeriod" => "1" }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      resp = vendAdapter(api_hash, details)
      if resp.status == 200
        logResponse(resp)
        resp
      else
        raise "An error with this response code #{resp.status} has occurred. Response: #{resp.body}"
      end
    end

    def power(txref, account, provider_id, amount, cus_number)
      params_hash = { "ref" => txref, "account" => account, "type" => provider_id, "amount" => amount,
                      "customernumber" => cus_number }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      resp = vendAdapter(api_hash, details)
      if resp.status == 200
        logResponse(resp)
        resp
      else
        raise "An error with this response code #{resp.status} has occurred. Response: #{resp.body}"
      end
    end

    def utility(txref, account, provider_id, amount, code)
      params_hash = { "ref" => txref, "account" => account, "type" => provider_id, "amount" => amount, "code" => code }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      begin
        response = vendAdapter(api_hash, details)
      rescue StandardError
        "error"
      else
        logResponse(response)
        response
      end
    end

    def get_transaction(transaction_id)
      params_hash = { "transactionid" => transaction_id }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      begin
        response = transactionAdapter(api_hash, details)
      rescue StandardError
        "error"
      else
        logResponse(response)
        JSON.parse(response.body)["details"]["message"]
      end
    end

    def products(product_id, product_type)
      params_hash = { "networkid" => product_id, "type" => product_type }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      begin
        response = productAdapter(api_hash, details)
      rescue StandardError
        "error"
      else
        logResponse(response)
        JSON.parse(response.body)["details"]["message"]
      end
    end

    def verify(product_type, account_id)
      params_hash = { "type" => product_type, "account" => account_id }
      details = {}
      details.merge!({ "details" => params_hash })
      api_hash = hash_req(details, ENV["AIRVEND_API_KEY"])
      begin
        response = verifyAdapter(api_hash, details)
      rescue StandardError
        "error"
      else
        logResponse(response)
        if response.status == 200
          JSON.parse(response.body)["details"]["message"]

        else
          raise "Service is unavailable"
        end
      end
    end

    def hash_req(details, apikey)
      api_hash = details.to_json + apikey
      Digest::SHA512.hexdigest api_hash
    end

    def headers(hashkey)
      {
        UpperCaseString.new("Content-Type") => "application/json",
        UpperCaseString.new("username") => ENV["AIRUID"],
        UpperCaseString.new("password") => ENV["AIRPASS"],
        UpperCaseString.new("hash") => hashkey,
        user_agent: "Airvend 1.0"
      }
    end

    def vendAdapter(api_hash, details)
      conn = faradayInit(api_hash)
      conn.post do |req|
        req.url "/secured/seamless/vend/"
        req.headers["hash"] = api_hash
        req.body = details.to_json
      end
    end

    def productAdapter(api_hash, details)
      conn =	faradayInit(api_hash)
      conn.post do |req|
        req.url "/secured/seamless/products/"
        req.headers["hash"] = api_hash
        req.body = details.to_json
      end
    end

    def verifyAdapter(api_hash, details)
      conn =	faradayInit(api_hash)
      conn.post do |req|
        req.url "/secured/seamless/verify/"
        req.headers["hash"] = api_hash
        req.body = details.to_json
      end
    end

    def transactionAdapter(api_hash, details)
      conn =	faradayInit(api_hash)
      conn.post do |req|
        req.url "/secured/seamless/transaction/"
        req.headers["hash"] = api_hash
        req.body = details.to_json
      end
    end

    def faradayInit(api_hash)
      Faraday.new(url: ENV["AIRVEND_API"], headers: headers(api_hash)) do |faraday|
        faraday.request :url_encoded
        faraday.response :detailed_logger
        faraday.adapter  :typhoeus
      end
    end

    def logResponse(response)
      if response.status == 200
        print "Was Successful, Ok"
      elsif response.status.between?(500, 505)
        print "----- #{response.status} The Problem is from us, please try again later -----"
      elsif response.status.between?(400, 417)
        print "----- #{response.status} Check the data you want to subscribe -----"
      end
    end
  end
end
