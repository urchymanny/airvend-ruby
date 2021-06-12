require "airvend/base/base.rb"
include Vend

class Vend::Airtime < Base

  def buy(payload)
		params_hash = { 'ref'=> payload[:ref], 'account'=> payload[:phone], 'networkid'=> mno_id(payload[:mno]), 'type'=> "1", 'amount'=> payload[:amount] }
		details = {}
		details.merge!({ 'details'=>params_hash })
		api_hash = @airvendObj.hash_req(details)
		response = vendAdapter(api_hash, details)
		if response.status == 200
      hash = rename_hash(JSON.parse(response.body, { symbolize_names: true }))
      rename_hash(hash[:details])
      hash
    else
      produce_error(response)
    end
	end

end


# input = [ref: "usdibisdbsidbsd", mno = "MTN", amount]
# Dotenv.load(File.expand_path("../.env", __FILE__))
# a = Airvend.new
# airtime = Vend::Airtime.new(Airvend.new)
# payload =  { ref: "YOUR-OWN-REF-HERE", account: "08138236694", mno: "mtn", amount: "200"}
