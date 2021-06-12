require "airvend/base/base.rb"
include Vend

class Vend::Power < Base

  def buy(payload)
    params_hash = { 'ref'=> txref, 'account'=> account, 'type'=> provider_id, 'amount'=> amount, 'customernumber'=> cus_number  }
		details = {}
		details.merge!({ 'details'=>params_hash })
		api_hash = @airvendObj.hash_req(details)
		resp = vendAdapter(api_hash, details)
		if resp.status == 200
      hash = rename_hash(JSON.parse(response.body, { symbolize_names: true }))
      rename_hash(hash[:details])
      hash
    else
      produce_error(response)
    end
  end

  def verify(payload)
    product_type = power_id(payload[:provider], payload[:account_type])
    verify_customer(product_type, payload[:account])
  end

end
