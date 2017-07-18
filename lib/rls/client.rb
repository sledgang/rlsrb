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

    # Returns a single season by ID
    # @param id [Integer]
    # @return [Season]
    def season(id)
      seasons[id]
    end

    # @return [Season] the current season
    def current_season
      seasons.values.find(&:current?)
    end
  end
end
