# Airvend Ruby

This gem makes it easy for businesses or individuals to implement vending of Airtime, Data, Electricity, Utilities & Television subscriptions to their application. This is a simplifiication of the [Airvend](https://airvend.ng) API

### Documentation

See [Here](https://documenter.getpostman.com/view/6349852/SVSHrpfv) for Airvend REST API Docs.

To use this resource, you would need to register on the [Airvend B2B](https://business.airvend.ng/) to get access to personal test API Keys or contact me hey@uche.io

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'airvend', "~> 0.1.2"
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

&nbsp;

you can also call the class with your credentials without Environment Variables pre set

```ruby
airvend = Airvend.new("YOUR-AIRVEND-USERNAME", "YOUR-AIRVEND-PASSWORD", "YOUR-AIRVEND-API-KEY")
```

Expect a `AirvendBadUserError`, `AirvendBadPassError`, or `AirvendBadKeyError` if the username, password or API key is missing or invalid respectively.

#### NOTE: It is best practice to always set your API keys to your environment variable for security purpose. Please be warned not use this package without setting your API keys in your environment variables in production.

&nbsp;

## Airvend Objects

- [VEND](#vend)
  - [Airtime Vending - Vend::Airtime.new(airvend)](#airtime-vending)
  - [Internet Data Vending - Vend::InternetData.new(airvend)](#internet-data-vending)
  - [Electricity Vending - Vend::Power.new(airvend)](#electricity-vending)
  - [TV Vending - Vend::Television](#tv-vending)

# VEND

To vend different services, you have access to the different classes for the different services

&nbsp;

## Airtime Vending

To vend airtime, you need to instantiate the Airtime Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

```ruby
airtime = Vend::Airtime.new(airvend)
```

&nbsp;

To purchase airtime for a phone number that is registered with any of the NCC licensed mobile networks `MTN`, `GLO`, `AIRTEL`, `9MOBILE` you can utilize the method below

First, we need to provide the required data in the payload

```ruby
payload =  {
	ref: "YOUR-OWN-REF-HERE",
	phone: "08138236694",
	mno: "mtn", # can also be `glo`, `airtel` or `9mobile`
	amount: "200"
}
```

&nbsp;

Next, we call the method to process the airtime purchase as shown below

```ruby
airtime.buy(payload)
```

&nbsp;

## Internet Data Vending

To vend Internet data subscriptions, you need to instantiate the `Internet` Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

```ruby
internet = Vend::Internet.new(airvend)
```

&nbsp;

To purchase internet data for a phone number that is registered with any of the NCC licensed mobile networks `MTN`, `GLO`, `AIRTEL`, `9MOBILE` you can utilize the method below

First, we need to fetch a list of available internet data plans for the selected mobile network with the payload

```ruby
internet_plans = internet.plans("mtn") # can also be `glo`, `airtel` or `9mobile`
```

 &nbsp;

This return an array of hashes with each containing a data plan in the format

```ruby
[
  ...
  {
    :description=>"350MB",
    :amount=>"300",
    :code=>"300",
    :validity=>" for 7 Days"
	}
  ...
]
```

#### Note the `code` is an identifier for the plan and is different from the amount

&nbsp;

Next, you can proceed to purchase the selected internet data plan with the payload

```ruby
payload =  {
	ref: "YOUR-OWN-REF-HERE",
	phone: "08138236694",
	mno: "mtn", # can also be `glo`, `airtel` or `9mobile`
	code: "200" # this is code from the selected internet data plan from the list of data plans
  }
```

&nbsp;

then we can proceed to make subscription after charging customer or your app user

```ruby
internet.buy(payload)
```

&nbsp;

## Electricity Vending

To vend Electricity Bills, you need to instantiate the `Power` Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

```ruby
power = Vend::Power.new(airvend)
```

&nbsp;

Before paying for electricity bills, it's important to confirm the customers details before proceeding

```ruby
payload = {
  account: "45701113131", #this is the customers meter number
  provider: "aedc",
  account_type: "prepaid" # can also be "postpaid"
}
```

&nbsp;

the following providers are supported:

- `aedc` for Abuja Electricity Distribution Company
- `ie` for Ikeja Electricity
- `eko` for Eko Distribution
- `phed` for Port Harcourt Electricity Distribution
- `eedc` for Enugu Electricity Distribution Company
- `kedco` for Kaduna Electricity Distribution Company
- `ibedc` for Ibadan Electricity Distribution Company

&nbsp;

To get the customer details, use the `verify` method

````ruby
customer = power.verify(payload)
````

which returns:

``` ruby
{
  :name=>"OLUWAFEMI ODIGIE",
  :accountstatus=>"OPEN",
  :customernumber=>"BA36F4AEF88763454678BF9D1A85E4AE6F166CECA01DE4B58C1100DA3DA87362A6CBD3410E2B7F809C1A33E1AD6756BBA853F4C0275270B398BC69E8AC050E75|eyJwcm9kdWN0IjoiUE9SVEhBUkNPVVJURUxFQ1RSSUNJVFkiLCJ0eXBlIjoiUFJFUEFJRCIsImFjY291bnQiOiIwMTI0MDAxMjQ3Njk5IiwibmFtZSI6IkVzIE9tYWNoaSIsImFkZHJlc3MiOiJOTyA2NSBXb2ppIFJkIE5PIDY1IFdvamkgUmQiLCJ0YXJyaWYiOiJSMiIsImFycmVhcnMiOiIwIiwicGhvbmUiOiIiLCJtZXRlck51bWJlciI6IjAxMjQwMDEyNDc2OTkiLCJjdXN0b21lck51bWJlciI6IjgxNDE3MDIyODMwMSIsInRvdGFsQmlsbCI6IjAiLCJpYmNOYW1lIjoiR2FyZGVuIENpdHkgSW5kdXN0cmlhbCIsImJzY05hbWUiOiJSdW11b2diYSJ9",
  :account=>"7021959296",
  :customeraccounttype=>""
}
```

&nbsp;

Finally, to purchase power for the verified customer, you would prepare a payload using the customer number that is gotten from the `verify` method

``` ruby
payload =  {
	ref: "YOUR-OWN-REF-HERE",
	account: "02188019141",
	provider: "aedc",
	amount: "2000",
	customernumber:"BA36F4AEF88763454678BF9D1A85E4AE6F166CECA01DE4B58C1100DA3DA87362A6CBD3410E2B7F809C1A33E1AD6756BBA853F4C0275270B398BC69E8AC050E75|eyJwcm9kdWN0IjoiUE9SVEhBUkNPVVJURUxFQ1RSSUNJVFkiLCJ0eXBlIjoiUFJFUEFJRCIsImFjY291bnQiOiIwMTI0MDAxMjQ3Njk5IiwibmFtZSI6IkVzIE9tYWNoaSIsImFkZHJlc3MiOiJOTyA2NSBXb2ppIFJkIE5PIDY1IFdvamkgUmQiLCJ0YXJyaWYiOiJSMiIsImFycmVhcnMiOiIwIiwicGhvbmUiOiIiLCJtZXRlck51bWJlciI6IjAxMjQwMDEyNDc2OTkiLCJjdXN0b21lck51bWJlciI6IjgxNDE3MDIyODMwMSIsInRvdGFsQmlsbCI6IjAiLCJpYmNOYW1lIjoiR2FyZGVuIENpdHkgSW5kdXN0cmlhbCIsImJzY05hbWUiOiJSdW11b2diYSJ9" #data contained in the response from verify customer method
}
```

The `customernumber` is contained in the response from the `verify` method

&nbsp;

Next, to process the power purchase, use the method below on the provided payload

```ruby
power.buy(payload)
```

&nbsp;

## TV Vending

To vend TV Subscriptions like DStv & GoTv, you need to instantiate the `Television` Class with the [`airvend`](#instantiate-airvend-object-in-sandbox-with-environment-variable) object

``` ruby
tv = Vend::Television
```

&nbsp;

Before paying for TV subscriptions, it's important to confirm the customers details before proceeding

``` ruby
payload = {
  provider: "dstv",
  account: "7021959296" # customer decoder iuc number
}
```

&nbsp;

To get the customer details, use the `verify` method

``` ruby
customer = tv.verify(payload)
```

which returns:

``` ruby
{
  :name=>"OLUWAFEMI ODIGIE",
  :accountstatus=>"OPEN",
  :customernumber=>56920080,
  :account=>"7021959296"
}
```

&nbsp;

Also, for processing TV Subscriptions, customers would be interested in selecting a subscription plan from their provider. You can get a list of available plans from each specific subscriber

``` ruby
tv_plans = tv.plans("dstv") # can also be `gotv`
```

This return an array of hashes with each containing a tv plans in the format

```ruby
[
  ...
  {
    :description=>"DStv Compact",
    :amount=> "7900",
    :code=>"COMPE36"
	}
  ...
]
```

&nbsp;

Finally, to subscribe to a tv plan for the verified customer, you would prepare a payload using the customer

``` ruby
payload =  {
	ref: "YOUR-OWN-REF-HERE",
	account: "02188019141",
	provider: "aedc",
  account_type: "prepaid",
	amount: "2000",
  customernumber: "56920080"
}
```

&nbsp;

next, to process the power purchase, use the method below on the provided payload

```ruby
tv.buy(payload)
```

&nbsp;

## Transactions

#### NOTE: This is currently not available.

&nbsp;

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/urchymanny/airvend-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/urchymanny/airvend-rails/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Airvend project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/urchymanny/airvend-rails/blob/master/CODE_OF_CONDUCT.md).
