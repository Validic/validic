require 'validic/response'
require 'validic/summary'

module Validic
  module REST
    module Utils
      private

      def build_response_attr(resp)
        summary = Validic::Summary.new(resp.delete("summary"))
        Validic::Response.new(summary, response_object(resp), self)
      end

      def response_object(resp)
        return resp.values.first if resp.values.first.is_a? Hash
        klass = Validic.const_get(camelize_response_key(resp))
        resp.values.flatten.collect { |obj| klass.new(obj) }
      end

      def camelize_response_key(resp)
        key = resp.keys.first
        key = key.include?('_') ? key.split('_').map(&:capitalize).join : key.capitalize
        key.chop! if %w(Users Apps).include?(key) #strip last letter off to match ::User or ::App
        key
      end
    end
  end
end
