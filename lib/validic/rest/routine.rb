require 'validic/routine'

module Validic
  module REST
    module Routine

      def get_routine(params = {})
        overwrite_creds(params)
        resp = get_request(:routine, params)
        build_response_attr(resp)
      end
      alias :get_routines :get_routine

      def create_routine(options = {})
        overwrite_creds(options)
        user_id = options.delete(:user_id)
        options = { user_id: user_id, routine: options }
        response = post_request(:routine, options)
        Validic::Routine.new(response['routine'])
      end

      def update_routine(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, routine: options }
        response = put_request(:routine, options)
        Validic::Routine.new(response['routine'])
      end

      def delete_routine(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:routine, options)
        true
      end

      def latest_routine(options = {})
        overwrite_creds(options)
        resp = latest(:routine, options)
        build_response_attr(resp)
      end
    end
  end
end
