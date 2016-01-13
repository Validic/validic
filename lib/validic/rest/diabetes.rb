require 'validic/diabetes'

module Validic
  module REST
    module Diabetes

      def get_diabetes(options = {})
        overwrite_creds(options)
        resp = get_request(:diabetes, options)
        build_response_attr(resp)
      end

      def create_diabetes(options = {})
        overwrite_creds(options)
        user_id = options.delete(:user_id)
        options = { user_id: user_id, diabetes: options }
        response = post_request(:diabetes, options)
        Validic::Diabetes.new(response['diabetes'])
      end

      def update_diabetes(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, diabetes: options }
        response = put_request(:diabetes, options)
        Validic::Diabetes.new(response['diabetes'])
      end

      def delete_diabetes(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:diabetes, options)
        true
      end

      def latest_diabetes(options = {})
        overwrite_creds(options)
        resp = latest(:diabetes, options)
        build_response_attr(resp)
      end
    end
  end
end
