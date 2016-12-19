# encoding: utf-8

module Validic
  module ThirdPartyApp

    ##
    # Get List of Third Party Apps available base on `access_token` and organization_id
    #
    # params[:organization_id] required parameter
    # params[:access_token] required parameter
    #
    # @return [Hashie::Mash] with list of Organization
    def get_apps(params={})
      params = extract_params(params)
      get("/#{Validic.api_version}/organizations/#{Validic.organization_id}/apps.json", params)
    end

    ##
    # Get User List of Third Party Synced Apps available base on `authentication_token`
    #
    # params[:auth_token] User authentication parameter
    #
    # @return [Hashie::Mash] with list of Organization
    def get_synced_apps(options={})
      options = {
        authentication_token: options[:authentication_token]
      }
      response = get("/#{Validic.api_version}/sync_apps.json", options)
      response if response
    end
  end
end
