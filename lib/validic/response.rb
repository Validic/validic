module Validic
  class Response
    include REST::Request
    attr_reader :summary, :records, :attributes

    def initialize(summary, response, client = nil)
      @summary = summary
      @client = client if client
      case response
      when Array
        @records = response
      when Hash
        @attributes = response
      end
    end

    def next
      extend Validic::REST::Utils
      return nil unless next_url = summary.next
      resp = get(next_url, {})
      build_response_attr(resp)
    end

    def previous
      extend Validic::REST::Utils
      return nil unless previous_url = summary.previous
      resp = get(previous_url, {})
      build_response_attr(resp)
    end

    def connection
      @client.connection
    end
  end
end
