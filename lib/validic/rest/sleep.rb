require 'validic/sleep'

module Validic
  module REST
    module Sleep

      def get_sleep(options = {})
        overwrite_creds(options)
        resp = get_request(:sleep, options)
        build_response_attr(resp)
      end
      alias :get_sleeps :get_sleep

      def create_sleep(options = {})
        overwrite_creds(options)
        user_id = options.delete(:user_id)
        options = { user_id: user_id, sleep: options }
        response = post_request(:sleep, options)
        Validic::Sleep.new(response['sleep'])
      end

      def update_sleep(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, sleep: options }
        response = put_request(:sleep, options)
        Validic::Sleep.new(response['sleep'])
      end

      def latest_sleep(options = {})
        overwrite_creds(options)
        resp = latest(:sleep, options)
        build_response_attr(resp)
      end

      def delete_sleep(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:sleep, options)
        true
      end

    end
  end
end
