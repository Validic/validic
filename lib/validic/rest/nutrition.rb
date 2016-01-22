require 'validic/nutrition'

module Validic
  module REST
    module Nutrition

      def get_nutrition(options = {})
        build_response(get_request(:nutrition, options))
      end
      alias :get_nutritions :get_nutrition

      def create_nutrition(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, nutrition: options }
        response = post_request(:nutrition, options)
        Validic::Nutrition.new(response['nutrition'])
      end

      def update_nutrition(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, nutrition: options }
        response = put_request(:nutrition, options)
        Validic::Nutrition.new(response['nutrition'])
      end

      def delete_nutrition(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:nutrition, options)
        true
      end

      def latest_nutrition(options = {})
        build_response(latest(:nutrition, options))
      end
    end
  end
end
