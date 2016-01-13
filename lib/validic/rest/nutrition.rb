require 'validic/nutrition'

module Validic
  module REST
    module Nutrition

      def get_nutrition(options = {})
        overwrite_creds(options)
        resp = get_request(:nutrition, options)
        build_response_attr(resp)
      end
      alias :get_nutritions :get_nutrition

      def create_nutrition(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, nutrition: options }
        response = post_request(:nutrition, options)
        Validic::Nutrition.new(response['nutrition'])
      end

      def update_nutrition(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, nutrition: options }
        response = put_request(:nutrition, options)
        Validic::Nutrition.new(response['nutrition'])
      end

      def delete_nutrition(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:nutrition, options)
        true
      end

      def latest_nutrition(options = {})
        overwrite_creds(options)
        resp = latest(:nutrition, options)
        build_response_attr(resp)
      end
    end
  end
end
