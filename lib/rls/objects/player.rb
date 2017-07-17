# frozen_string_literal: true

require 'rls/objects/stats'

module RLS
  # A Rocket League player, as tracked by RLS
  class Player
    # @return [String] Steam 64 ID, or PSN Username, or Xbox GamerTag or XUID
    attr_reader :id

    # @return [String]
    attr_reader :display_name

    # @return [Platform] platform on which this player is playing on
    attr_reader :platform

    # @return [String] URL to this player's avatar
    attr_reader :avatar

    # @return [String] URL to this player's profile on RLS
    attr_reader :profile_url

    # @return [String] URL to this player's signature image on RLS
    attr_reader :signature_url

    # @return [Stats] this player's accumulated stats to date
    attr_reader :stats

    # @return [Time]
    attr_reader :last_requested

    # @return [Time]
    attr_reader :created_at

    # @return [Time]
    attr_reader :updated_at

    # @return [Time]
    attr_reader :next_update

    def initialize(data)
      @id             = data['uniqueId']
      @display_name   = data['displayName']
      @platform       = Platform.new(data['platform'])
      @avatar         = data['avatar']
      @profile_url    = data['profileUrl']
      @signature_url  = data['signatureUrl']
      @stats          = Stats.new(data['stats'])

      @last_requested = RLS::Utils.time(data['lastRequested'])
      @created_at     = RLS::Utils.time(data['createdAt'])
      @updated_at     = RLS::Utils.time(data['updatedAt'])
      @next_update    = RLS::Utils.time(data['nextUpdateAt'])
    end
  end
end
