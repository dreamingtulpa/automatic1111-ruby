# frozen_string_literal: true

require "automatic1111/configurable"
require "automatic1111/connection"

module Automatic1111
  class Client
    include Automatic1111::Configurable
    include Automatic1111::Connection

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Automatic1111::Configurable.keys.each do |key|
        value = options.key?(key) ? options[key] : Automatic1111.instance_variable_get(:"@#{key}")
        instance_variable_set(:"@#{key}", value)
      end
    end
  end
end
