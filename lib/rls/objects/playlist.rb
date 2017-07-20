# frozen-string-literal: true

module RLS
  # A Rocket League playlist, and participation statistics
  class Playlist
    # @return [Integer]
    attr_reader :id

    # @return [String]
    attr_reader :name

    # @return [Integer]
    attr_reader :population

    # @return [Time]
    attr_reader :updated_at

    def initialize(data)
      @id = data['id']
      @name = data['name']
      @population = data['population']['players']
      @updated_at = Utils.time(data['population']['updatedAt'])
    end
  end
end
