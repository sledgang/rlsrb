require 'time'

module RLS
  module Utils
    module_function
    def time(ts)
      Time.at(ts)
    end
  end
end
