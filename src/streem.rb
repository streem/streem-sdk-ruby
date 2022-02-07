# frozen_string_literal: true

require "streem/version"
require "streem/token_builder"

# Provides access to the Streem SDK.  Start by calling Streem.init() with your API Key ID and Secret
module Streem
  @api_key_id = nil
  @api_key_secret = nil
  @api_environment = "prod-us"

  # Define static-like behavior using the metaclass.  This allows auto-generation of the accessor methods,
  # and singleton initialization of the Streem variables.
  class << self
    attr_reader :api_key_id, :api_key_secret
    attr_accessor :api_environment

    def init(api_key_id, api_key_secret)
      @api_key_id = api_key_id
      @api_key_secret = api_key_secret
    end
  end
end
