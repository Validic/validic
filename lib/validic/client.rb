# encoding: utf-8
require 'forwardable'
require 'validic/request'
require 'validic/organization'
require 'validic/activity'
require 'validic/user'
require 'validic/profile'
require 'validic/fitness'
require 'validic/weight'
require 'validic/nutrition'
require 'validic/sleep'
require 'validic/diabetes'
require 'validic/biometric'
require 'validic/routine'
require 'validic/tobacco_cessation'
require 'validic/third_party_app'

module Validic
  class Client
    extend Forwardable

    include Request
    include Organization
    include Activity
    include User
    include Profile
    include Fitness
    include Weight
    include Nutrition
    include Sleep
    include Diabetes
    include Biometric
    include Routine
    include TobaccoCessation
    include ThirdPartyApp

    attr_reader :api_url, :api_version, :access_token

    ##
    # Create a new Validic::Client object
    #
    # @params options[Hash]
    def initialize(options={})
      @api_url        = options[:api_url]       || Validic.api_url
      @api_version    = options[:api_version]   || Validic.api_version || 'v1'
      @access_token   = options[:access_token]  || Validic.access_token
      @organization_id   = options[:organization_id]  || Validic.organization_id
    end

    ##
    # Create a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      params = {}
      @connection = Faraday.new(url: api_url, params: params, headers: default_headers, ssl: {verify: false}) do |faraday|
        faraday.use FaradayMiddleware::Mashify
        faraday.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
      end
    end

    private

    def default_headers
      headers = {
        accept: 'application/json',
        content_type: 'application/json',
        user_agent: "Ruby Gem by Validic #{Validic::VERSION}"
      }
    end

  end
end
