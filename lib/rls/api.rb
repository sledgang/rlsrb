# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'rls/objects/platform'
require 'rls/objects/player'
require 'rls/objects/season'

module RLS
  # Mixin binding to RocketLeagueStats' REST API
  module API
    # The base URL of the RocketLeagueStats API
    APIBASE = 'https://api.rocketleaguestats.com/v1/'

    # Retrieve a single player
    # @param id [String, Integer] The unique identifier:
    #   Steam 64 ID / PSN Username / Xbox GamerTag or XUID
    # @param platform [Platform, Integer] The platform to use
    # @return [Player] The player object
    # @raise [ArgumentError] when platform does not resolve to an integer
    def player(id, platform = Platform::Steam)
      platform = platform.respond_to?(:id) ? platform.id : platform
      raise ArgumentError, 'Argument platform must resolve to an Integer' unless platform.is_a?(Integer)
      response =
        request(
          :get,
          :player,
          params: {
            unique_id: id,
            platform_id: platform
          }
        )
      Player.new(response)
    end

    # Retrieve a batch of players
    # @example Retrieve a batch of players from multiple platforms
    #   client.players(
    #     76561198033338223, 1,
    #     76561197981122126, RLS::Platform::Steam,
    #     'Wizwonk', 2,
    #     'Loubleezy', RLS::Platform::XboxOne
    #   )
    # @param *request_data [Array<String,Integer,#id>] list of player IDs and their platform
    # @return [Array<Player>] Array of Player objects
    def players(*request_data)
      raise ArgumentError, 'Provided uneven pairing of ID and platform' unless request_data.size.even?
      post_data = []
      request_data.each_slice(2) do |id, platform|
        id = id.to_s
	platform = platform.respond_to?(:id) ? platform.id : platform
        post_data << { uniqueId: id, platformId: platform }
      end
      raise ArgumentError, 'Can\'t request more than 10 players' if post_data.size > 10
      response =
        request(
          :post,
          'player/batch',
          post_data.to_json,
          content_type: :json
        )
      response.map { |e| Player.new(e) }
    end


    # Retrieve the different platforms unless they've already been cached
    # @param renew [true, false] Ignore the cache and make a new request
    # @return [Array<Platform>] An array of platform objects
    def platforms(renew = false)
      if renew || !@platforms
        response =
          request(
            :get,
            'data/platforms'
          )
        @platforms =
          response.map { |e| Platform.new(e) }
      else
        @platforms
      end
    end

    # Retrieve season information
    # @param renew [true, false] Ignore the cache and make a new request
    # @return [Hash<Integer => Season] The seasons by ID
    def seasons(renew = false)
      if renew || !@seasons
        response =
          request(
            :get,
            'data/seasons'
          )
        @seasons =
          response.map { |data| [data['seasonId'], Season.new(data)] }.to_h
      else
        @seasons
      end
    end

    # @param type [String, Symbol] HTTP verb
    # @param endpoint [String, Symbol] The API endpoint
    # @param attributes [Array<Hash>] Header and query parameters
    #   passed along with the request
    # @return [Hash] The parsed JSON response
    def request(type, endpoint, *attributes)
      attributes << {} if attributes.empty?
      response = raw_request(type, endpoint, attributes)
      JSON.parse(response)
    end

    private

    # @param type [String, Symbol] HTTP verb
    # @param endpoint [String, Symbol] The API endpoint
    # @param attributes [Array<Hash>] Header and query parameters
    #   passed along with the request
    # @return [RestClient::Response] The response from RestClient
    # @raise [RLS::Error::MissingKey] if @api_key is `nil`
    # @raise [RLS::Error::InvalidKey] if the API rejects `@api_key`
    def raw_request(type, endpoint, attributes)
      raise RLS::Error::MissingKey unless @api_key
      attributes.last[:authorization] = @api_key
      RestClient.send(type, APIBASE + endpoint.to_s, *attributes)
    rescue RestClient::Unauthorized
      raise RLS::Error::InvalidKey
    end
  end
end
