# frozen_string_literal: true

require_relative "automatic1111/version"
require_relative "automatic1111/client"

module Automatic1111
  class Error < StandardError; end

  class << self
    include Automatic1111::Configurable

    def client
      return @client if defined?(@client)
      @client = Automatic1111::Client.new(options)
    end
  end
end
