require 'validic/organization'

module Validic
  module REST
    module Organizations
      def get_organization(params = {})
        build_response(get_request(:organizations, params))
      end
    end
  end
end
