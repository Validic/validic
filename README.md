# Validic #

## Build Status
[![Codeship Status for Validic/validic](https://www.codeship.io/projects/cc4ff330-9f72-0130-3cf3-0e5a3e2104f7/status?branch=master)](https://www.codeship.io/projects/3456)

## Stable Version: 0.4.1

Ruby API Wrapper for [Validic](http://www.validic.com/api/docs). It includes the
following functionality:

## Breaking Changes ##
- Methods for user provisioning, suspending, and deleting have been renamed
- Methods will now default to initialized values unless overridden in options

### Organization ###
- Organization metadata

### Users ###
- Provision new Validic users
- Update, Suspend, or Delete users
- Get users from organization credentials
- Find user id from authentication token
- Refresh user authentication token

### Profiles ###
- Get profile information from user authentication token
- Create and modify user profiles

### Apps ###
- List available third party apps
- List synced apps for a particular user

### Activities ###
- Fitness, Routine, Nutrition, Sleep, Weight, Diabetes, Biometrics, Tobacco
  Cessation
- Get activities scoped to user or organization
- Activities from specific sources
- Specified time ranges

### Connect ###
- Create activities as a Validic Connect partner
- Post extra data
- Update or Delete activities by Validic activity id

### Latest Endpoint ###
- Get latest data recorded, regardless of when the activity occurred
- Scope to organization or user level
- Specify start and end points

## Installation
Add this line to your application's Gemfile:

    gem 'validic'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validic

## Usage

##### Rails 3+
First, instantiate the client.
```ruby
require 'validic'

# config/initializers/validic.rb
Validic.configure do |config|
  config.api_url          = 'https://api.validic.com'
  config.api_version      = 'v1'
  config.access_token     = 'ORGANIZATION_ACCESS_TOKEN'
  config.organization_id  = 'ORGANIZATION_ID'
end

# Create a Client Object provided you have an initializer
client = Validic::Client.new
```

##### Plain ruby
```ruby

options = {
  api_url:         'https://api.validic.com',
  api_version:     'v1',
  access_token:    'ORGANIZATION_ACCESS_TOKEN',
  organization_id: 'ORGANIZATION_ID'
}
client = Validic::Client.new(options)
```

Now you can use the wrapper's helper methods to interface with the Validic API.
```ruby
# Get current organization metadata
client.get_organization
```

When your requests return an object they are returned as a Validic::Response
object. The Validic::Response typically includes summary metadata and an array
of record objects.
```ruby
client.get_routine.summary.results
client.get_routine.records.first.steps
```

You can pass a hash of options to calls that fetch data.
```ruby
client.get_routine(start_date: '2015-01-01T00:00:00+00:00')
```

### More Examples ###

Below are examples of all helper methods.

```ruby
require 'validic'

# Alternatively you can use an initializer
options = {
  api_url:         'https://api.validic.com',
  api_version:     'v1',
  access_token:    'ORGANIZATION_ACCESS_TOKEN',
  organization_id: 'ORGANIZATION_ID'
}
client = Validic::Client.new options
```

## Organization methods

### Get Requests
Get requests will always return a Validic::Response object.  It will look like this:
```ruby
sleeps = client.get_sleep
=> #<Validic::Response:0x007ff3c9e4daa8
 @records=
  [#<Validic::Sleep:0x007ff3c9e4eb60
    @_id="54b9242798b4b18fff00000d",
    @awake=12.0,
    @deep=nil,
    @last_updated="2015-01-16T14:45:59+00:00",
    @light=nil,
    @rem=nil,
    @source="healthy_yet",
    @source_name="HealthyYet",
    @times_woken=nil,
    @timestamp="2015-01-16T14:45:38+00:00",
    @total_sleep=nil,
    @user_id="54a2eda484626bb50a00002c",
    @utc_offset="+00:00">
 @summary=
  #<Validic::Summary:0x007ff3c9e4eea8
   @end_date="2015-01-17T23:59:59+00:00",
   @limit=100,
   @message="Ok",
   @next=nil,
   @offset=0,
   @previous=nil,
   @results=2,
   @start_date="2015-01-15T00:00:00+00:00",
   @status=200,
   @timestamp=nil>>
```

Now you have access to a `Summary` object and an array of activity objects.  You can step through either object like so:

```ruby
sleeps.summary
=> #<Validic::Summary:0x007ff3ca2d98d8
 @end_date="2015-01-17T23:59:59+00:00",
 @limit=100,
 @message="Ok",
 @next=nil,
 @offset=0,
 @previous=nil,
 @results=2,
 @start_date="2015-01-15T00:00:00+00:00",
 @status=200,
 @timestamp=nil>


sleeps.summary.status
=> 200


sleeps.records.first
=> #<Validic::Sleep:0x007ff3ca2d9590
 @_id="54b9242798b4b18fff00000d",
 @awake=12.0,
 @deep=nil,
 @last_updated="2015-01-16T14:45:59+00:00",
 @light=nil,
 @rem=nil,
 @source="healthy_yet",
 @source_name="HealthyYet",
 @times_woken=nil,
 @timestamp="2015-01-16T14:45:38+00:00",
 @total_sleep=nil,
 @user_id="54a2eda484626bb50a00002c",
 @utc_offset="+00:00">


sleeps.records.first.awake
=> 12.0
```

##### Get current organization
```ruby
client.get_organization
```

##   [User methods](https://validic.com/api/docs#users)

##### Get users from organization credentials
```ruby
client.get_users
```

Get user by Validic user id.
```ruby
client.get_users(user_id: '5499a29b84626b0339000094')
```

##### Refresh authentication token
```ruby
client.refresh_token(user_id: '5499a29b84626b0339000094')
```

##### Get user_id from authentication token
```ruby
client.me(authentication_token: 'L9RFSRnJvkwfiZm8vEc4')
```

##### Provision new users
```ruby
client.provision_user(uid: '123')
```

With optional profile.
```ruby
client.provision_user(uid: '123', profile: { gender: 'M' })
```

##### Updating a user
```ruby
client.update_user(user_id: '5499a29b84626b0339000094', uid: '123')
```

With optional profile.
```ruby
client.update_user(user_id: '5499a29b84626b0339000094', uid: '123', profile: { gender: 'M' })
```

##### Suspend a user
```ruby
client.suspend_user(user_id: '5499a29b84626b0339000094')
```

##### Unsuspend a user
```ruby
client.unsuspend_user(user_id: '5499a29b84626b0339000094')
```

##### Delete a user
```ruby
client.delete_user(user_id: '5499a29b84626b0339000094')
```

##   [Profile methods](https://validic.com/api/docs#profile)

##### Get a user profile
```ruby
client.get_profile(authentication_token: 'L9RFSRnJvkwfiZm8vEc4')
```

##### Create a user profile
```ruby
client.create_profile(authentication_token: 'L9RFSRnJvkwfiZm8vEc4', gender: 'M')
```

##   Apps methods

##### Get a list of available third-party-apps
```ruby
client.get_org_apps
```

##### Get a list of apps a user is synced to
```ruby
client.get_user_synced_apps(authentication_token: 'L9RFSRnJvkwfiZm8vEc4')
```

##   Activity methods

###### You can also filter the results of the following methods by passing an options hash

##### Get an array of fitness records
```ruby
client.get_fitness
```

##### Get an array of routine records
```ruby
client.get_routine
```

##### Get an array of nutrition records
```ruby
client.get_nutritions
```

##### Get an array of weight records
```ruby
client.get_weight
```

##### Get an array of diabetes records
```ruby
client.get_diabetes
```

##### Get an array of biometrics records
```ruby
client.get_biometrics
```

##### Get an array of sleep records
```ruby
client.get_sleep
```

##### Get an array of tobacco cessation records
```ruby
client.get_tobacco_cessations
```

##### Get the next page of a Validic::Response
```ruby
data = client.get_routine(start_date: '2013-01-01', paginated: "true")
data.next
```

##### Get the previous page of a Validic::Response
```ruby
data = client.get_routine(start_date: '2013-01-01', paginated: "true", page: 3)
data.previous
```

##   [Validic Connect](https://validic.com/api/partners)


##### CRUD Operations
As a Validic Connect partner you have access to all CRUD operations.

**Create**
```ruby
client.create_sleep(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID', awake: 2, rem: 1, deep: 7)
=>  #<Validic::Sleep:0x007fafcc2cdd40
 @_id="54b93e1b84626b0581000012",
 @activity_id="22323",
 @awake=2.0,
 @deep=7.0,
 @extras=nil,
 @last_updated="2015-01-16T16:36:43+00:00",
 @light=nil,
 @rem=1.0,
 @source="healthy_yet",
 @source_name="Healthy Yet",
 @times_woken=nil,
 @timestamp="2015-01-16T16:36:43+00:00",
 @total_sleep=nil,
 @utc_offset=nil,
 @validated=false>
```

**Update**

```ruby
client.update_sleep(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID', timestamp: DateTime.now.new_offset(0).iso8601, rem: 4)

=> #<Validic::Sleep:0x007fafcc38fd28
 @_id="54b93e1b84626b0581000012",
 @activity_id="22323",
 @awake=2.0,
 @deep=7.0,
 @extras=nil,
 @last_updated="2015-01-16T16:38:23+00:00",
 @light=nil,
 @rem=4.0,
 @source="healthy_yet",
 @source_name="Healthy Yet",
 @times_woken=nil,
 @timestamp="2015-01-16T16:38:02+00:00",
 @total_sleep=nil,
 @utc_offset=nil,
 @validated=false>
[13] pry(main)>
```

**Delete**

```ruby
client.delete_sleep(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID')
=> true
```

All objects have the same actions as outlined below.


##### [Fitness](https://validic.com/api/docs/#fitness)
```ruby
client.create_fitness(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID', options)
client.update_fitness(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID', options)
client.delete_fitness(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID')
```

##### [Routine](https://validic.com/api/docs/#routine)
```ruby
client.create_routine(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID', options)
client.update_routine(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID', options)
client.delete_routine(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID')
```

##### [Nutrition](https://validic.com/api/docs/#nutrition)
```ruby
client.create_nutrition(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ENTRY_ID', options)
client.update_nutrition(user_id: 'VALIDIC_USER_ID', _id: 'UNIQUE_ENTRY_ID', options)
client.delete_nutrition(user_id: 'VALIDIC_USER_ID', _id: 'UNIQUE_ENTRY_ID')
```

##### [Weight](https://validic.com/api/docs/#weight)
```ruby
client.create_weight(user_id: 'VALIDIC_USER_ID', data_id: 'UNIQUE_ENTRY_ID', options)
client.update_weight(user_id: 'VALIDIC_USER_ID', _id: 'UNIQUE_ENTRY_ID', options)
client.delete_weight(user_id: 'VALIDIC_USER_ID', _id: 'UNIQUE_ENTRY_ID')
```

##### [Diabetes](https://validic.com/api/docs/#diabetes)
```ruby
client.create_diabetes(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID', options)
client.update_diabetes(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID', options)
client.delete_diabetes(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID')
```

##### [Biometrics](https://validic.com/api/docs/#biometrics)
```ruby
client.create_biometrics(user_id: 'VALIDIC_USER_ID', data_id: 'UNIQUE_ENTRY_ID', options)
client.update_biometrics(user_id: 'VALIDIC_USER_ID', _id: 'UNIQUE_ENTRY_ID', options)
client.delete_biometrics(user_id: 'VALIDIC_USER_ID', _id: 'UNIQUE_ENTRY_ID')
```

##### [Sleep](https://validic.com/api/docs/#sleep)
```ruby
client.create_sleep(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID', options)
client.update_sleep(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_SLEEP_ID', options)
client.delete_sleep(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID')
```

##### [Tobacco Cessation](https://validic.com/api/docs/#tobacco_cessation)
```ruby
client.create_tobacco_cessation(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID' options)
client.update_tobacco_cessation(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID', options)
client.delete_tobacco_cessation(user_id: 'VALIDIC_USER_ID', _id: 'VALIDIC_ACTIVITY_ID')
```

##### You can also create data with your own custom extras as JSON
```ruby
client.create_fitness(user_id: 'VALIDIC_USER_ID', activity_id: 'UNIQUE_ACTIVITY_ID', extras: "{\"stars\": 3}")
```

##   [Latest Records](https://validic.com/api/bulkdata/#latest)

###### You can also pass an options hash to filter latest results

##### Pull latest records for specified type
```ruby
client.latest_routine
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
