require 'validic/app'

module Validic
  module REST
    module Apps

      def get_org_apps(params = {})
        resp = get_request(:apps, params)
        Validic::Response.new(resp)
      end
      alias :get_apps :get_org_apps

      def get_user_synced_apps(options = {})
        resp = get_request(:sync_apps,
                           authentication_token: options[:authentication_token])
        Validic::Response.new(resp)
      end
      alias :get_synced_apps :get_user_synced_apps
    end
  end
end
