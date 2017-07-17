module RLS
  module Error
    class MissingKey < RuntimeError
      def message
        'You need to supply a valid API key'
      end
    end

    class InvalidKey < RuntimeError
      def message
        'Invalid API key'
      end
    end
  end
end
