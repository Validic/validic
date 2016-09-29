module Validic
  class Railtie < ::Rails::Railtie
    config.before_initialize do
      begin
        VALIDIC_CONFIG = Rails.application.config_for(:validic)

        Validic.configure do |validic|
          validic.api_url         = VALIDIC_CONFIG['api_url']
          validic.api_version     = VALIDIC_CONFIG['api_version']
          validic.access_token    = VALIDIC_CONFIG['validic_acess_token']
          validic.organization_id = VALIDIC_CONFIG['validic_organisation_id']
        end
      rescue
        raise MissingConfiguration, 'You must define a validic.yml config file in the rails app'
      end
    end
  end
end
