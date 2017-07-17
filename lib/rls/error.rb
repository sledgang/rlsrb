module RLS
  module Error
    class MissingKey < RuntimeError; end
    class InvalidKey < RuntimeError; end
  end
end
