# frozen_string_literal: true

require 'rest-client'
require 'json'
require 'time'
require 'rls/objects/platform'
require 'rls/objects/player'
require 'rls/objects/season'
require 'rls/objects/search_results'

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

    # Retrieves a batch of up to 10 players at a time from different platforms
    # @example Retrieve a batch of players from different platforms
    #   client.players(
    #     76561198033338223, 1,
    #     76561197981122126, RLS::Platform::Steam,
    #     'Wizwonk', 2,
    #     'Loubleezy', RLS::Platform::XboxOne
    #   )
    # @param *request_data [Array<String, Integer, #id>] list of player IDs and their platform
    # @raise [ArgumentError] if the provided arguments are uneven
    # @raise [ArgumentError] if the amount exceeds 10 players
    # @return [Array<Player>] Array of Player objects
    def players(*request_data)
      raise ArgumentError, 'Provided uneven pairing of ID and platform' unless request_data.size.even?
      post_data = Utils.batch_players_from_array(request_data)
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

    # Searches RLS's database for players matching a given display name.
    # The response is paginated.
    # @example Retrieve the results, one page at a time
    #   results = client.search('player')
    #   results.players #=> first page
    #   results.next_page #=> next page of players
    #   results.next_page #=> next page of players
    #   results.players #=> all players read so far
    # @example Retrieve all results, if there is more than one page
    #   results = client.search('player')
    #   results.all #=> all players from all paginated responses
    #
    # @param display_name [String]
    # @param page [Integer]
    # @return [SearchResults]
    def search(display_name, page = 0)
      response =
        request(
          :get,
          'search/players',
          params: {
            display_name: display_name,
            page: page
          }
        )
      SearchResults.new(self, response, display_name)
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

    # Performs a mutex-protected request to the API with rate limit handling.
    # @param type [String, Symbol] HTTP verb
    # @param endpoint [String, Symbol] The API endpoint
    # @param attributes [Array<Hash>] Header and query parameters
    #   passed along with the request
    # @return [Hash] The parsed JSON response
    def request(type, endpoint, *attributes)
      attributes << {} if attributes.empty?
      @mutex ||= Mutex.new

      @mutex.synchronize do
        sleep until_reset if will_be_rate_limited?

        begin
          @last_response = raw_request(type, endpoint, attributes)
        rescue RestClient::TooManyRequests
          sleep until_reset
          retry
        end

        JSON.parse(@last_response)
      end
    end

    private

    # @return [String, nil] if it exists, the specific header from the last API request
    def last_header(key)
      @last_response&.headers&.dig(key)
    end

    # @return [Float] the amount of time until the rate limit resets
    def until_reset
      (last_header(:x_rate_limit_reset_remaining) || 0).to_i / 1000.0
    end

    # @return [Integer] number of requests until we're rate limited
    def remaining_requests
      last_header(:x_rate_limit_remaining)&.to_i || -1
    end

    # @return [Time, nil] if it exists, when the rate limit will be reset
    def rate_limit_reset
      str = last_header(:x_rate_limit_reset)
      Time.parse(str) if str
    end

    # @return [true, false] if the next request will be rate limited
    def will_be_rate_limited?
      return false unless @last_response
      return false if Time.now > rate_limit_reset
      remaining_requests.zero?
    end

    # Performs a request to the API. Not protected by a rate-limit mutex!
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
