require 'validic/biometrics'

module Validic
  module REST
    module Biometrics

      def get_biometrics(options = {})
        overwrite_creds(options)
        resp = get_request(:biometrics, options)
        build_response_attr(resp)
      end

      def create_biometrics(options = {})
        overwrite_creds(options)
        user_id = options.delete(:user_id)
        options = { user_id: user_id, biometrics: options }
        response = post_request(:biometrics, options)
        Validic::Biometrics.new(response['biometrics'])
      end

      def update_biometrics(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id, biometrics: options }
        response = put_request(:biometrics, options)
        Validic::Biometrics.new(response['biometrics'])
      end

      def delete_biometrics(options = {})
        overwrite_creds(options)
        user_id, _id = options.delete(:user_id), options.delete(:_id)
        options = { user_id: user_id, _id: _id }
        delete_request(:biometrics, options)
        true
      end

      def latest_biometrics(options = {})
        overwrite_creds(options)
        resp = latest(:biometrics, options)
        build_response_attr(resp)
      end
    end
  end
end
