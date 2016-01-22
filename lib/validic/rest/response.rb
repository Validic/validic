require 'validic/response'

module Validic
  module REST
    module Response
      private

      def build_response(response)
        Validic::Response.new(response, connection)
      end
    end
  end
end
