# frozen_string_literal: true

module RLS
  module Error
    # Raised when `@api_key` is not provided to the REST wrapper in `API`
    # when performing a request.
    class MissingKey < RuntimeError
      # @return [String] the default message returned for this exception
      def message
        'You need to supply a valid API key'
      end
    end

    # Raised when `@api_key` is rejected by the API
    # when performing a request.
    class InvalidKey < RuntimeError
      # @return [String] the default message returned for this exception
      def message
        'Invalid API key'
      end
    end
  end
end
