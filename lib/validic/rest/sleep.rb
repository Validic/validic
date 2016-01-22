require 'validic/sleep'

module Validic
  module REST
    module Sleep

      def get_sleep(options = {})
        build_response(get_request(:sleep, options))
      end
      alias :get_sleeps :get_sleep

      def create_sleep(options = {})
        user_id = options.delete(:user_id)
        options = { user_id: user_id, sleep: options }
        response = post_request(:sleep, options)
        Validic::Sleep.new(response['sleep'])
      end

      def update_sleep(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, sleep: options }
        response = put_request(:sleep, options)
        Validic::Sleep.new(response['sleep'])
      end

      def latest_sleep(options = {})
        build_response(latest(:sleep, options))
      end

      def delete_sleep(options = {})
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:sleep, options)
        true
      end

    end
  end
end
