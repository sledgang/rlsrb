# frozen_string_literal: true

module RLS
  class Stats
    attr_reader :wins
    attr_reader :goals
    attr_reader :mvp
    attr_reader :saves
    attr_reader :shots
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
