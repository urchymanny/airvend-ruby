# frozen_string_literal: true

# require_relative "airvend/version"
require "dotenv"
require 'json'
require 'digest'
require 'airvend/vend.rb'
require 'airvend/base_endpoints.rb'
require 'airvend/errors.rb'
require 'airvend/upper_case_string.rb'
require 'airvend/airvend_objects/airtime.rb'
require 'airvend/airvend_objects/internet.rb'
require 'airvend/airvend_objects/power.rb'
require 'airvend/airvend_objects/television.rb'

Dotenv.load(File.expand_path("../.env", __FILE__))

class Airvend
  attr_accessor :username, :password, :api_key, :production, :url

  def initialize(username=nil, password=nil, api_key=nil, production=false)

    @username = username
    @password = password
    @api_key = api_key
    @production = production
    sandbox_url = BASE_ENDPOINTS::SANDBOX_URL
    live_url = BASE_ENDPOINTS::LIVE_URL

    if (ENV['RAILS_ENV'].nil?)
      @production = production
      warn "Warning: Make sure you set RAILS_ENV to production or development"
    else
      if ENV['RAILS_ENV'] == "production"
        @production=true
      else
        @prodcution=false
      end
    end

    # set rave url to sandbox or live if we are in production or development
    if production == false
        @url = sandbox_url
    else
        @url = live_url
    end

    # check if we set our public and secret keys to the environment variable
    if (username.nil? && password.nil?)
      @username = ENV['AIRVEND_USERNAME']
      @password = ENV['AIRVEND_PASSWORD']
    else
      @username = username
      @password = password
      warn "Warning: To ensure your account credentials are safe, It is best to always set your password in the environment variable with AIRVEND_USERNAME & AIRVEND_PASSWORD"
    end

    # raise this error if no username is passed
    unless !@username.nil?
      raise AirvendBadUserError, "No Username supplied and couldn't find any in environment variables. Make sure to set public key as an environment variable AIRVEND_USERNAME"
    end

    # raise this error if no password is passed
    unless !@password.nil?
      raise AirvendBadPassError, "No password supplied and couldn't find any in environment variables. Make sure to set secret key as an environment variable AIRVEND_PASSWORD"
    end


    if (api_key.nil?)
      @api_key = ENV['AIRVEND_API_KEY']
    else
      @api_key = api_key
      warn "Warning: To ensure your account key is safe, It is best to always set your password in the environment variable with AIRVEND_API_KEY"
    end

    # raise this error if no username is passed
    unless !@api_key.nil?
      raise AirvendBadKeyError, "No Api Key supplied and couldn't find any in environment variables. Make sure to set public key as an environment variable AIRVEND_USERNAME"
    end
  end

  # method to return the base url
  def base_url
    return url
  end

  def headers(hashkey)
    return {
    	UpperCaseString.new('Content-Type') => 'application/json',
      UpperCaseString.new('username') => self.username,
      UpperCaseString.new('password') => self.password,
      UpperCaseString.new('hash') => hashkey,
      user_agent: "Airvend-0.1.0"
    }
  end

  def hash_req(details)
    api_hash = details.to_json+self.api_key
    api_hash = Digest::SHA512.hexdigest api_hash
    return api_hash
  end



end
