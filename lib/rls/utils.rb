# frozen_string_literal: true

require 'time'

module RLS
  # A helper module of various utility methods
  module Utils
    module_function

    # Parses a unix epoch time into a `Time` object.
    #
    # @param ts [Integer] epoch time
    # @return [Time]
    def time(ts)
      Time.at(ts)
    end
  end
end
