# frozen_string_literal: true

require "test_helper"
require "jwt"
require "active_support/core_ext/numeric/time.rb"

class StreemTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Streem::VERSION
  end

  def test_token_creation
    api_key_id = "api_4l1HLLbAKfiNcyU5fyPxPu"
    api_key_secret = "eyJrdHkiOiJFQyIsImQiOiJzR3VqdFFrZEJkcmFvN0NMUmZTMlQ0N1M1STdwV2NleTNwMzV6RWtmLXVnIiwidXNlIjoic2lnIiwiY3J2IjoiUC0yNTYiLCJ4IjoiY3VMYi1oZTg1NkFRM2NNOW9xVnBPRWJWcEg2WGJsXy16ZmdQTEFPdGVIOCIsInkiOiJwQ180eEtVYUVvQ3B1X0p0MktVNXY3ZjR1VXZ4ZllnNDc4MHNWYkpqd2dNIiwiYWxnIjoiRVMyNTYifQ"

    Streem.init(api_key_id, api_key_secret)
    Streem.api_environment = "test"

    builder = Streem::TokenBuilder.new
    builder.user_id = "tester"
    builder.name = "Test"
    builder.avatar_url = "https://tr.rbxcdn.com/680e8cd3b087d56459a92b93120b152d/352/352/Avatar/Png"
    builder.email = "test@streem.pro"
    builder.token_expiration_ms = 10 * 60 * 1000 # ten minutes
    builder.session_expiration_ms = 60 * 60 * 1000 # one hour
    builder.reservation_sid = "rsv_abc123"

    token = builder.token
    refute_nil token

    decoded_token = JWT.decode(token, nil, false)
    payload = decoded_token.first

    assert_equal "streem:api:#{api_key_id}", payload["iss"]
    assert_equal "tester", payload["sub"]
    assert_equal "Test", payload["name"]
    assert_equal "https://tr.rbxcdn.com/680e8cd3b087d56459a92b93120b152d/352/352/Avatar/Png", payload["picture"]
    assert_equal "test@streem.pro", payload["email"]
    assert_equal "https://api.test.streem.cloud/", payload["aud"]
    assert_equal "rsv_abc123", payload["streem:reservation_sid"]

    # Expiration dates should be within 1 second of those specified
    assert_in_delta (Time.now + 10.minutes).to_i, Time.at(payload["exp"]).to_i, 1
    assert_in_delta (Time.now + 60.minutes).to_i, Time.at(payload["session_exp"]).to_i, 1
  end
end
