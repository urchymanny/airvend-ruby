require "airvend/base/base.rb"
include Vend

class Vend::Internet < Base

  def buy(payload)
		params_hash = { 'ref'=> payload[:ref], 'account'=> payload[:phone], 'networkid'=> mno_id(payload[:mno]), 'type'=> "2", 'amount'=> payload[:code] }
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

  def plans(provider)
    data = serialize_plans(get_plans(provider, "2")[:details][:message])
  end

  def serialize_plans(plans)
    plans.sort_by{|e| e[:amount].to_i}.each do |bundle|
      if bundle[:validity] == nil
         bundle[:validity] = "Unlimited"
      elsif bundle[:validity].include? 'Day'
        bundle[:validity].insert(0, " for ")
        bundle[:validity]['Day'] = ' Day'
      elsif bundle[:validity].include? 'Hours'
        bundle[:validity].insert(0, " for ")
        bundle[:validity]['Hours'] = ' Hours'
      elsif bundle[:validity].include? 'Month'
        bundle[:validity].insert(0, " for ")
        bundle[:validity]['Month'] = ' Month'
      elsif bundle[:validity].include? 'Year'
        bundle[:validity].insert(0, " for ")
        bundle[:validity]['Year'] = ' Year'
      end
    end
  end

end
