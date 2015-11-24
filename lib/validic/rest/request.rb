require 'multi_json'
require 'validic/error'

module Validic
  module REST
    module Request
      MAX_RECORDS = 2_000
      PAGINATED_ENDPOINTS = [
                              :biometrics,
                              :diabetes,
                              :fitness,
                              :nutrition,
                              :routine,
                              :sleep,
                              :tobacco_cessation,
                              :weight
                            ]

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

      def paginated_request(type, options = {})
        path = construct_path(type, options)
        init_call = get(path, options)
        records = init_call[type.to_s]
        next_url = init_call["summary"]["next"]
        previous_url = nil
        loop do
          break if next_url.nil? || records.size >= MAX_RECORDS
          next_page = get(next_url, options)
          records << next_page[type.to_s]
          records = records.flatten
          next_url = next_page["summary"]["next"]
          previous_url = next_page["summary"]["previous"]
        end
        init_call[type.to_s] = records
        summary_merge = {
          "limit" => MAX_RECORDS,
          "next" => (next_url ? next_url.gsub("&paginated=true", "") : nil),
          "previous" => (previous_url ? previous_url.gsub("&paginated=true", "") : nil)
        }
        init_call["summary"].merge!(summary_merge)
        init_call
      end

      def get_request(type, options = {})
        if options[:paginated] == "true" && PAGINATED_ENDPOINTS.include?(type)
          paginated_request(type, options)
        else
          path = construct_path(type, options)
          get(path, options)
        end
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
        options[:access_token] = options[:access_token].nil? ? Validic.access_token : options[:access_token]
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
