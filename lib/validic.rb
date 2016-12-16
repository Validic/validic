require 'validic/client'

module Validic
  BASE_URL = "https://api.validic.com/v1"
  class << self
    attr_accessor :api_url,
      :api_version,
      :access_token,
      :organization_id

    ##
    # Configure default
    #
    # @yield [Validic]
    def configure
      yield self
      true
    end

    def api_url
      @api_url ||= "https://api.validic.com"
    end

    def api_version
      @api_version ||= "v1"
    end
  end
end
