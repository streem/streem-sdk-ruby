# streem-sdk-ruby

Server-side ruby library for interacting with the Streem API, and generation of Streem Tokens for use in client SDKs or Embedded SSO.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'streem'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install streem

## Usage

First, import the library:

```ruby
require "streem"
```

Then initialize the library with your API Key ID and Secret:

```ruby
Streem.init(api_key_id, api_key_secret)
```

### Streem Tokens

To create a Streem Token, first create a `TokenBuilder`:

```ruby
builder = Streem::TokenBuilder.new
```

Then specify the details for the currently logged-in user:
```ruby
user = # your logged in user

# required
builder.user_id = user.id

# recommended
builder.name = user.name
builder.email = user.email
builder.avatar_url = user.avatar

# optional
builder.token_expiration_ms = ... # Determines how long this token is valid for starting a session (default 5 minutes)
builder.session_expiration_ms = ... # Once the session has started, how long can the user remain logged in (default 4 hours)

# If using the Group Reservation feature, set the reservation sid from the API response
builder.reservation_sid = ...
```

Finally, call `token` to generate the token string:
```ruby
token = builder.token
```

#### Embedded SSO

Embedded SSO allows you to create Streem Tokens server-side, and automatically log your users into the Streem web application.

First, provide the `token` created above to your front-end browser client.  Next, place the token in the hash portion of any Streem web application URL,
by appending `#token=...` with your token.

For example, to create an `iframe` to the root page in streem, you might have:

```html
<iframe src="https://{company-code}.streempro.app/embed#token={token}"/>
```

Be sure to substitute `{company-code}` and `{token}` for the correct values.

#### Streem Client SDKs

If using the iOS or Android SDKs, you will provide the Streem Token to the client, and pass to the SDK via `Streem.identify()`.  More
details can be found in documentation of the individual SDKs

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
