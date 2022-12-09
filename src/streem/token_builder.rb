# frozen_string_literal: true

require "base64"
require "jose"

module Streem
  # Class for building Streem Tokens.  Configure the token using the available setter methods, and finalize the token
  # by calling `builder.token`.  This returns a string representation of the token, that can be provided to the client.
  class TokenBuilder
    attr_accessor :user_id, :name, :email, :avatar_url, :token_expiration_ms, :session_expiration_ms, :reservation_sid

    def initialize
      @token_expiration_ms = 5 * 60 * 1000 # five minutes
      @session_expiration_ms = 4 * 60 * 60 * 1000 # four hours
    end

    # Build the token using the configured attributes.  Validation errors may be raised from this method
    def token
      validate_token

      key_as_json = Base64.decode64(Streem.api_key_secret)
      jwk = JOSE::JWK.from(key_as_json)

      claim = token_claims
      claim['streem:reservation_sid'] = @reservation_sid if @reservation_sid

      # noinspection RubyStringKeysInHashInspection
      signed_token = JOSE::JWS.sign(jwk, claim.to_json, { "alg" => "ES256" })
      signed_token.compact
    end

    private

    def validate_token
      raise "Must call Streem.init first" if Streem.api_key_id.nil? || Streem.api_key_secret.nil?
      raise "Cannot build token: user_id is required" if @user_id.nil?
    end

    def token_claims
      {
        iss: "streem:api:#{Streem.api_key_id}",
        sub: @user_id.to_s,
        exp: Time.now.to_i + (@token_expiration_ms / 1000).to_i,
        session_exp: Time.now.to_i + (@session_expiration_ms / 1000).to_i,
        iat: Time.now.to_i,
        aud: "https://api.#{Streem.api_environment}.streem.cloud/",
        name: @name,
        email: @email,
        picture: @avatar_url
      }
    end
  end
end
