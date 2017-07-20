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

    # Returns a single tier by ID
    # @param id [Integer]
    # @return [Tier]
    def tier(id)
      tiers[id]
    end

    # @return [Season] the current season
    def current_season
      seasons.values.find(&:current?)
    end

    # Find a platform by ID or name
    # @param id [Integer, Symbol] the ID or name (in lowercase) of the platform
    # @raise [ArgumentError] if id is not an `Integer` or `Symbol`
    def platform(id)
      return platforms.find { |p| p.id == id } if id.is_a? Integer
      return platforms.find { |p| p.name.downcase.to_sym == id } if id.is_a? Symbol
      raise ArgumentError, 'id must be one of type Integer or Symbol'
    end
  end
end
