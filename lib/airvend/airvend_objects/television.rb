require "airvend/base/base.rb"
include Vend

class Vend::Television < Base

  def verify(payload)
    verify_customer(tv_id(payload[:provider]), payload[:account])
  end

  def plans(provider)
    get_plans(provider, "2")[:details][:message]
  end
end
