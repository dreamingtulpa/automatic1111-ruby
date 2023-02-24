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
    def get(url, params: {}, headers: {})
      request :get, url, params, headers: headers
    end

    def post(url, params: {}, headers: {})
      request :post, url, params, headers: headers
    end

    def put(url, params: {}, headers: {})
      request :put, url, params, headers: headers
    end

    def patch(url, params: {}, headers: {})
      request :patch, url, params, headers: headers
    end

    def delete(url, params: {}, headers: {})
      request :delete, url, params, headers: headers
    end

    def head(url, params: {}, headers: {})
      request :head, url, params, headers: headers
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
