# frozen_string_literal: true

require 'rls/objects/stats'

module RLS
  class Player
    attr_reader :id
    attr_reader :display_name
    attr_reader :platform
    attr_reader :avatar
    attr_reader :profile_url
    attr_reader :signature_url
    attr_reader :stats
    attr_reader :last_requested
    attr_reader :created_at
    attr_reader :updated_at
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
