# frozen_string_literal: true

module Automatic1111
  module Configurable
    attr_accessor :api_endpoint_url, :cookie, :read_timeout

    class << self
      # List of configurable keys for {Datatrans::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= %i[api_endpoint_url cookie read_timeout]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    def read_timeout
      @read_timeout ||= 60
    end

    private

    def options
      Hash[Automatic1111::Configurable.keys.map { |key| [key, send(key)] }]
    end
  end
end
