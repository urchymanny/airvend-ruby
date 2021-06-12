require "airvend/base/base.rb"
include Vend

class Vend::Television < Base

  def buy(payload)
    params_hash = { 'ref'=> payload[:ref], 'account'=> payload[:account], 'type'=> tv_id(payload[:provider]), 'amount'=> payload[:amount], 'customernumber'=> payload[:customernumber], 'invoicePeriod'=>"1" }
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
    verify_customer(tv_id(payload[:provider]), payload[:account])[:details][:message]
  end

  def plans(provider)
    plans = get_plans("", tv_id(provider))[:details][:message]
    new_plans = plans.each { |p| p.delete(:descrition); p[:description] = p.delete :name; p[:amount] = p[:amount].to_s}
  end
end
