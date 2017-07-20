# frozen-string-literal: true

module RLS
  # A ranked tier in Rocket League
  class Tier
    # @return [Integer]
    attr_reader :id

    # @return [String]
    attr_reader :name

    def initialize(data)
      @id = data['tierId']
      @name = data['tierName']
    end
  end
end
