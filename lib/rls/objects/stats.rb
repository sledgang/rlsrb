# frozen_string_literal: true

module RLS
  # A player's overall stats, as recorded by RLS
  class Stats
    # @return [Integer]
    attr_reader :wins

    # @return [Integer]
    attr_reader :goals

    # @return [Integer]
    attr_reader :mvps

    # @return [Integer]
    attr_reader :saves

    # @return [Integer]
    attr_reader :shots

    # @return [Integer]
    attr_reader :assists

    def initialize(data)
      @wins    = data['wins']
      @goals   = data['goals']
      @mvps    = data['mvps']
      @saves   = data['saves']
      @shots   = data['shots']
      @assists = data['assists']
    end
  end
end
