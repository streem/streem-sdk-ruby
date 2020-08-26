# streem-sdk-ruby

Server-side ruby library for interacting with the Streem API, and generation of Embedded SSO Tokens.

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

### Embedded SSO Token

To create an Embedded SSO Token, first create a `TokenBuilder`:

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
```

Finally, call `token` to generate the token string:
```ruby
    token = builder.token
```

Now provide `token` to your front-end client.  This token can be placed on Streem URLs to automatically authenticate the user.

For example, to create an `iframe` to the embed page in streem, you might have:

```html
    <iframe src="https://{company-code}.streempro.app#token={token}"/>
```

Be sure to substitute `{company-code}` and `{token}` for the correct values.
