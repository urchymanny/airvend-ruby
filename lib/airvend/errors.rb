
class AirvendServerError < StandardError
	attr_reader :response
	def initialize(response=nil)
		@response = response
	end
end

class AirvendBadUserError < StandardError
end

class AirvendBadPassError < StandardError
end

class	AirvendBadKeyError < StandardError
end
