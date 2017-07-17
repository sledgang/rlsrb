# frozen_string_literal: true

require 'rls/error'
require 'rls/api'
require 'rls/utils'

module RLS
  # A Client that abstracts a user's API key from REST requests,
  # and provides other helpful higher-level functionality.
  class Client
    include API

    def initialize(api_key)
      @api_key = api_key
    end
  end
end
