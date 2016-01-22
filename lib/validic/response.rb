require 'validic/summary'

module Validic
  class Response
    include REST::Request
    attr_reader :summary, :records, :attributes

    def initialize(response, connection = nil)
      @connection = connection
      @summary = summary_object(response)
      case resp = response_object(response)
      when Array
        @records = resp
      when Hash
        @attributes = resp
      end
    end

    def next
      return nil unless next_url = summary.next
      resp = get(next_url, {})
      self.class.new(resp, connection)
    end

    def previous
      return nil unless previous_url = summary.previous
      resp = get(previous_url, {})
      self.class.new(resp, connection)
    end

    private

    def connection
      @connection
    end

    def summary_object(resp)
      Validic::Summary.new(resp.delete("summary"))
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
