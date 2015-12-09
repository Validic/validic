require 'validic/profile'

module Validic
  module REST
    module Profile
      def get_profile(options = {})
        overwrite_creds(options)
        resp = get_request(:profile, options)
        Validic::Profile.new(resp)
      end

      def create_profile(options = {})
        overwrite_creds(options)
        token = options.delete(:authentication_token)
        resp = post_request(:profile, authentication_token: token, profile: options)
        Validic::Profile.new(resp['profile'])
      end
    end
  end
end
