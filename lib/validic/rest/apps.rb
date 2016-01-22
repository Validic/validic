require 'validic/app'

module Validic
  module REST
    module Apps

      def get_org_apps(params = {})
        build_response(get_request(:apps, params))
      end
      alias :get_apps :get_org_apps

      def get_user_synced_apps(options = {})
        build_response(get_request(:sync_apps,
                           authentication_token: options[:authentication_token]))
      end
      alias :get_synced_apps :get_user_synced_apps
    end
  end
end
