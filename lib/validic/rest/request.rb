require 'multi_json'
require 'validic/error'

module Validic
  module REST
    module Request
      def latest(type, options = {})
        organization_id = options[:organization_id] || Validic.organization_id
        user_id = options.delete(:user_id)
        if user_id
          path = "/#{Validic.api_version}/organizations/#{organization_id}/users/#{user_id}/#{type.to_s}/latest.json"
        else
          path = "/#{Validic.api_version}/organizations/#{organization_id}/#{type.to_s}/latest.json"
        end
        get(path, options)
      end

      private

      def get_request(type, options = {})
        path = construct_path(type, options)
        get(path, options)
      end

      def post_request(type, options = {})
        path = construct_path(type, options)
        post(path, options)
      end

      def put_request(type, options = {})
        path = construct_path(type, options)
        put(path, options)
      end

      def delete_request(type, options = {})
        path = construct_path(type, options)
        delete(path, options)
      end

      def construct_path(type, options)
        organization_id = options.delete(:organization_id) || Validic.organization_id
        user_id = options.delete(:user_id)
        activity_id = options.delete(:_id)
        if activity_id
          path = "/#{Validic.api_version}/organizations/#{organization_id}/users/#{user_id}/#{type.to_s}/#{activity_id}.json"
        elsif user_id && type == :users
          path = "/#{Validic.api_version}/organizations/#{organization_id}/users/#{user_id}.json"
        elsif user_id
          path = "/#{Validic.api_version}/organizations/#{organization_id}/users/#{user_id}/#{type.to_s}.json"
        elsif type == :me
          path = "/#{Validic.api_version}/me.json"
        elsif type == :profile
          path = "/#{Validic.api_version}/profile.json"
        elsif type == :organizations
          path = "/#{Validic.api_version}/organizations/#{organization_id}.json"
        else
          path = "/#{Validic.api_version}/organizations/#{organization_id}/#{type.to_s}.json"
        end
        path
      end

      def get(path, options)
        request(:get, path, options)
      end

      def post(path, options)
        request(:post, path, options)
      end

      def put(path, options)
        request(:put, path, options)
      end

      def delete(path, options)
        request(:delete, path, options)
      end

      def request(method, path, options)
        options[:access_token] = options.fetch(:access_token, Validic.access_token)
        options[:organization_id] = options.fetch(:organization_id, Validic.organization_id)
        response = connection.send(method) do |request|
          case method
          when :get
            request.url(path, options)
          when :post, :put, :delete
            request.path = path
            request.body = MultiJson.encode(options) unless options.empty?
          end
        end
        error = Validic::Error::ERRORS[response.status]
        raise error.from_response(response.body) if error
        response.body
      end
    end
  end
end
