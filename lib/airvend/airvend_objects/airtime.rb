require "airvend/base/base.rb"
include Vend

class Vend::Airtime < Base

  def buy(payload)
		params_hash = { 'ref'=> payload[:ref], 'account'=> payload[:phone], 'networkid'=> mno_id(payload[:mno]), 'type'=> "1", 'amount'=> payload[:amount] }
		details = {}
		details.merge!({ 'details'=>params_hash })
		api_hash = @airvendObj.hash_req(details)
		resp = vendAdapter(api_hash, details)
		if resp.status == 200
				logResponse(resp)
        return resp
    else
        raise "An error with this response code #{resp.status} has occurred. Response: #{resp.body}"
    end
	end

end


# input = [ref: "usdibisdbsidbsd", mno = "MTN", amount]
# Dotenv.load(File.expand_path("../.env", __FILE__))
# a = Airvend.new
# airtime = Vend::Airtime.new(a)
# payload =  { ref: "YOUR-OWN-REF-HERE", account: "08138236694", mno: "mtn", amount: "200"}
