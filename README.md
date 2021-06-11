# Airvend Ruby

This gem makes it easy for businesses or individuals to implement vending of Airtime, Data, Electricity, Utilities & Television subscriptions to their application. This is a simplifiication of the [Airvend](https://airvend.ng) API

### Documentation

See [Here](https://documenter.getpostman.com/view/6349852/SVSHrpfv) for Airvend REST API Docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'airvend'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install airvend

## Usage

### Initialization

#### Instantiate Airvend object in sandbox with environment variable:

To use the Airvend Gem, you need to instantiate the Airvend class with your credentials including your Username, Password & API Key. Best practice requires you to add your credentials to your Environment Variables `AIRVEND_USERNAME`, `AIRVEND_PASSWORD` & `AIRVEND_API_KEY`. You can call the new method on the Airvend Class afterwards

```ruby
airvend = Airvend.new
```

you can also call the class with your credentials without Environment Variables pre set

```ruby
airvend = Airvend.new("YOUR-AIRVEND-USERNAME", "YOUR-AIRVEND-PASSWORD", "YOUR-AIRVEND-API-KEY")
```

Expect a `AirvendBadUserError`, `AirvendBadPassError`, or `AirvendBadKeyError` if the username, password or API key is missing or invalid respectively.

#### NOTE: It is best practice to always set your API keys to your environment variable for security purpose. Please be warned not use this package without setting your API keys in your environment variables in production.

## Airvend Objects

- [VEND](#vend)
  - [Airtime Vending - VEND::Airtime.new(airvend)](#airtime-vending)
  - [Internet Data Vending - VEND::InternetData.new(airvend)](#internet-data-vending)
  - [Electricity Vending - VEND::Power.new(airvend)](#electricity-vending)
  - [TV Vending](#tv-vending)

# VEND

To vend different services, you have access to the different classes for the different services

## Airtime Vending

To vend airtime, you need to instantiate the Airtime Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

```ruby
airtime = Vend::Airtime.new(airvend)
```

To purchase airtime for a phone number that is registered with any of the NCC licensed mobile networks `MTN`, `GLO`, `AIRTEL`, `9MOBILE` you can utilize the method below

First, we need to provide the required data in the payload

```ruby
payload =  { 
	ref: "YOUR-OWN-REF-HERE", 
	account: "08138236694", 
	mno: "mtn", # can also be `glo`, `airtel` or `9mobile`
	amount: "200"
}
```

Next, we call the method to process the airtime purchase as shown below

```ruby
airtime.buy(payload)
```



## Internet Data Vending

To vend Internet data subscriptions, you need to instantiate the `InternetData` Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

## coming soon



## Electricity Vending

To vend Electricity Bills, you need to instantiate the `Power` Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

## coming soon



## TV Vending

To vend TV Subscriptions like DStv & GoTv, you need to instantiate the `TV` Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

## coming soon



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/urchymanny/airvend-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/urchymanny/airvend-rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Airvend project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/urchymanny/airvend-rails/blob/master/CODE_OF_CONDUCT.md).

