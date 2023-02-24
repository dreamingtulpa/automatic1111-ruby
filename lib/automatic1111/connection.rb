# frozen_string_literal: true

require 'byebug'
require "faraday"
require "faraday/net_http"
require "faraday/retry"
require "faraday/multipart"
require "addressable/uri"

module Automatic1111
  # Network layer for API clients.
  module Connection
    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {}, headers: {})
      request :get, url, options, headers: headers
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def post(url, options = {}, headers: {})
      request :post, url, options, headers: headers
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def put(url, options = {}, headers: {})
      request :put, url, options, headers: headers
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def patch(url, options = {}, headers: {})
      request :patch, url, options, headers: headers
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def delete(url, options = {}, headers: {})
      request :delete, url, options, headers: headers
    end

    # Make a HTTP HEAD request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def head(url, options = {}, headers: {})
      request :head, url, options, headers: headers
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    def last_response
      @last_response if defined? @last_response
    end

    private

    def request(method, path, data, headers: {})
      headers['Content-Type'] ||= 'application/json'
      headers['Cookie'] ||= cookie

      connection = Faraday.new(url: api_endpoint_url) do |conn|
        conn.request :retry
        conn.adapter :net_http
      end

      # @last_response = connection.send(method, Addressable::URI.parse(path.to_s).normalize.to_s, data)
      @last_response = connection.send(method, Addressable::URI.parse(path.to_s).normalize.to_s) do |req|
        req.headers = headers
        case headers["Content-Type"]
        when 'application/x-www-form-urlencoded'
          req.body = URI.encode_www_form(data)
        else
          req.body = data.to_json
        end
      end

      case @last_response.status
      when 400
        raise Error, "#{@last_response.status} #{@last_response.reason_phrase}: #{JSON.parse(@last_response.body)}"
      else
        self.cookie = @last_response.headers['set-cookie'] if @last_response.headers['set-cookie']

        case headers["Content-Type"]
        when 'application/json'
          JSON.parse(@last_response.body)
        else
          @last_response.body
        end
      end
    end
  end
end
