module Vend

  def vendAdapter(api_hash, details)
  	conn = connect(api_hash)
		response = conn.post do |req|
		  req.url '/secured/seamless/vend/'
		  req.headers['hash'] = api_hash
		  req.body = details.to_json
		end
		return response
  end

  def productAdapter(api_hash, details)
		conn = 	connect(api_hash)
		response = conn.post do |req|
		  req.url '/secured/seamless/products/'
		  req.headers['hash'] = api_hash
		  req.body = details.to_json
		end
		return response
	end

  def verifyAdapter(api_hash, details)
		conn = 	connect(api_hash)
		response = conn.post do |req|
		  req.url '/secured/seamless/verify/'
		  req.headers['hash'] = api_hash
		  req.body = details.to_json
		end
		return response
	end

  def logResponse(response)
    if response.status == 200
      print "Was Successful, Ok"
    elsif response.status.between?(500,505)
      print "----- #{response.status} The Problem is from us, please try again later -----"
    elsif response.status.between?(400,417)
      print "----- #{response.status} Check the data you want to subscribe -----"
    end
  end

end
