module RLS
  # Search results from RLS
  class SearchResults
    # @return [String] the search query
    attr_reader :display_name

    # @return [Integer] current page
    attr_reader :page

    # @return [Integer] amount of results in this query
    attr_reader :results

    # @return [Integer] total amount of players returned by the query
    attr_reader :total_results

    # @return [Integer]
    attr_reader :max_results_per_page

    # @return [Array<Player>] array of Player objects that have been fetched so far
    attr_reader :players

    def initialize(client, data, display_name)
      @client               = client
      @display_name         = display_name
      @page                 = data['page']
      @results              = data['results']
      @total_results        = data['totalResults']
      @max_results_per_page = data['maxResultsPerPage']
      @players              = data['data'].map { |e| Player.new(e) }
    end

    # @return [Array<Player>] Retrieves the next page of Player objects
    def next_page
      return [] if results < max_results_per_page
      @page += 1
      search = @client.search(display_name, page)
      @results = search.results
      @players += search.players
      search.players
    end

    # Continuously requests all available pages that the query can produce, and returns all of the player objects
    # @return [Array<Player>] All the players from the query
    def all
      until next_page.empty?
      end
      players
    end
  end
end
