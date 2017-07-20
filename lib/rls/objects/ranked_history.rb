# frozen-string-literal: true

module RLS
  # An entry in a player's ranked history
  class RankedHistory
    # @return [Integer]
    attr_reader :playlist_id

    # @return [Integer]
    attr_reader :rank_points

    # @return [Integer, nil]
    attr_reader :matches_played

    # @return [Integer, nil]
    attr_reader :tier_id

    # @return [Integer, nil]
    attr_reader :division

    def initialize(playlist_id, data)
      @playlist_id = playlist_id
      @rank_points = data['rankPoints']
      @matches_played = data['matchesPlayed']
      @tier_id = data['tier']
      @division = data['division']
    end
  end
end
