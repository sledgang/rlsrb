# frozen_string_literal: true

module RLS
  # A Rocket League season, as tracked by RLS
  class Season
    # @return [Integer] The season ID
    attr_reader :id

    # @return [Time] Season start time
    attr_reader :started_on

    # @return [Time, nil] Season end time, nil if season hasn't ended
    attr_reader :ended_on

    def initialize(data)
      @id         = data['seasonId']
      @started_on = RLS::Utils.time(data['startedOn'])
      ended_on    = data['endedOn']
      @ended_on   = ended_on.nil? ? nil : RLS::Utils.time(ended_on)
    end

    # @return [true, false] Is this the current season?
    def current?
      @ended_on.nil?
    end
  end
end
