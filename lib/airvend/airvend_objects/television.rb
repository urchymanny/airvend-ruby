require "airvend/base/base.rb"
include Vend

class Vend::Television < Base

  def verify(payload)
    verify_customer(tv_id(payload[:provider]), payload[:account])[:details][:message]
  end

  def plans(provider)
    plans = get_plans("", tv_id(provider))[:details][:message]
    new_plans = plans.each { |p| p.delete(:descrition); p[:description] = p.delete :name; p[:amount] = p[:amount].to_s}
  end
end
