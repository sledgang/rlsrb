# frozen_string_literal: true

module RLS
  # A Client that abstracts a user's API key from REST requests,
  # and provides other helpful higher-level functionality.
  class Client
    include API
  end
end
