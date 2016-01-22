require 'validic/diabetes'

module Validic
  module REST
    module Diabetes

      def get_diabetes(options = {})
        build_response(get_request(:diabetes, options))
      end

      def create_diabetes(options = {})
        user_id = options.delete(:user_id)
        options = { user_id: user_id, diabetes: options }
        response = post_request(:diabetes, options)
        Validic::Diabetes.new(response['diabetes'])
      end

      def update_diabetes(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, diabetes: options }
        response = put_request(:diabetes, options)
        Validic::Diabetes.new(response['diabetes'])
      end

      def delete_diabetes(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:diabetes, options)
        true
      end

      def latest_diabetes(options = {})
        build_response(latest(:diabetes, options))
      end
    end
  end
end
