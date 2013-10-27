# Validic

Ruby API Wrapper for [Validic](http://www.validic.com)

## Build Status
[![Codeship Status for Validic/validic](https://www.codeship.io/projects/cc4ff330-9f72-0130-3cf3-0e5a3e2104f7/status?branch=master)](https://www.codeship.io/projects/3456)

## Installation

Add this line to your application's Gemfile:

    gem 'validic'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validic

## Usage

```ruby
    require 'validic'

    # If you're using Rails 3+
    # config/initializers/validic.rb
    Validic.configure do |config|
      config.api_url        = 'https://api.validic.com'
      config.api_version    = 'v1'
    end

    # If your using plain RUBY
    # Create Validic::Client Object
    options = {
      api_url: 'https://api.validic.com',
      api_version: 'v1',
      access_token: 'DEMO_KEY' # Replace this with your key
    }
    client = Validic::Client.new options

    # Create a Client Object expecting you have an initializer in place
    # Validic::Client Object
    client = Validic::Client.new

    # => Get Account Activities
    client.get_activities

    # => Get Organization Activities
    client.get_activites({organization_id: "YOUR_organization_id",
                          access_token: "YOUR_ACCESS_TOKEN"})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
