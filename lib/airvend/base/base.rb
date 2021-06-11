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
      raise "Invalid Mobile Network Operator"
    end
  end

end
