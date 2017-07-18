# frozen_string_literal: true

require 'time'

module RLS
  # A helper module of various utility methods
  module Utils
    module_function

    # Parses a unix epoch time into a `Time` object.
    #
    # @param ts [Integer] epoch time
    # @return [Time]
    def time(ts)
      Time.at(ts)
    end

    # Build an array of hashes for use with the batch endpoint
    #
    # @param request_data [Array] list of player IDs and their platform
    # @return Array<Hash>
    def batch_players_from_array(request_data)
      post_data = []
      request_data.each_slice(2) do |id, platform|
        id = id.to_s
        platform = platform.respond_to?(:id) ? platform.id : platform
        post_data << { uniqueId: id, platformId: platform }
      end
      post_data
    end
  end
end
