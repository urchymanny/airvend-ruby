
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

class AirvendInvalidProvider < StandardError
end

class	AirvendConflictError < StandardError
end

class	AirvendBadRequestError < StandardError
end

class	AirvendUnauthorizedError < StandardError
end

class	AirvendNotFoundError < StandardError
end

class	AirvendIncorrectPayload < StandardError
end

class	AirvendUnknownClientError < StandardError
end
