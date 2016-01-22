require 'validic/weight'

module Validic
  module REST
    module Weight

      def get_weight(params={})
        build_response(get_request(:weight, params))
      end
      alias :get_weights :get_weight

      def create_weight(options={})
        user_id = options.delete(:user_id)
        options = { user_id: user_id, weight: options }
        resp = post_request(:weight, options)

        Validic::Weight.new(resp['weight'])
      end

      def update_weight(options={})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, weight: options }
        response = put_request(:weight, options)
        Validic::Weight.new(response["weight"])
      end

      def delete_weight(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:weight, options)
        true
      end

      def latest_weight(options={})
        build_response(latest(:weight, options))
      end
    end
  end
end
