require 'validic/client'

module Validic
  API_URL     = 'https://api.validic.com'
  API_VERSION = 'v1'
  BASE_URL    = "#{API_URL}/#{API_VERSION}"

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
  end
end

Validic.api_url     = Validic::API_URL
Validic.api_version = Validic::API_VERSION

