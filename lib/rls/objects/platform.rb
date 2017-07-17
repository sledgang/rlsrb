# frozen_string_literal: true

module RLS
  # A gaming platform that is tracked by RLS.
  # These change very rarely, and constants to the most common platforms
  # are provided so that users do not have to make an API request.
  class Platform
    # @return [Integer] ID of this platform
    attr_reader :id

    # @return [String] name of this platform
    attr_reader :name

    def initialize(data)
      @id = data['id']
      @name = data['name']
    end
  end

  Platform::Steam   = Platform.new('id' => 1, 'name' => 'Steam')
  Platform::Ps4     = Platform.new('id' => 2, 'name' => 'Ps4')
  Platform::XboxOne = Platform.new('id' => 3, 'name' => 'XboxOne')
end
