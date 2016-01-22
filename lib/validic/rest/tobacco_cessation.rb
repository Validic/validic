require 'validic/tobacco_cessation'

module Validic
  module REST
    module TobaccoCessation

      def get_tobacco_cessation(options = {})
        build_response(get_request(:tobacco_cessation, options))
      end
      alias :get_tobacco_cessations :get_tobacco_cessation

      def create_tobacco_cessation(options = {})
        user_id = options.delete(:user_id)
        options = { user_id: user_id, tobacco_cessation: options }
        response = post_request(:tobacco_cessation, options)
        Validic::TobaccoCessation.new(response['tobacco_cessation'])
      end

      def update_tobacco_cessation(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, tobacco_cessation: options }
        response = put_request(:tobacco_cessation, options)
        Validic::TobaccoCessation.new(response['tobacco_cessation'])
      end

      def delete_tobacco_cessation(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:tobacco_cessation, options)
        true
      end

      def latest_tobacco_cessation(options = {})
        build_response(latest(:tobacco_cessation, options))
      end
    end
  end
end
