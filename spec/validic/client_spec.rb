# encoding: utf-8
require 'spec_helper'

describe Validic::Client do

  describe '#initialize' do
    before(:each) do
      Validic.configure do |config|
        config.access_token = '1234'
        config.organization_id = 1
      end
    end

    it 'uses defaults' do
      client = Validic::Client.new

      expect(client.api_url).to eq 'https://api.validic.com'
      expect(client.api_version).to eq 'v1'
      expect(client.access_token).to eq '1234'
      expect(client.organization_id).to eq 1
    end

    it 'overrides default url and api_key' do
      Validic.configure do |config|
        config.api_url = 'http://test.example.com'
        config.api_version = 'v2'
      end

      client = Validic::Client.new

      expect(client.api_url).to eq 'http://test.example.com'
      expect(client.api_version).to eq 'v2'
    end

    it 'uses options' do
      opts = {
                api_url: 'http://test.example.com',
                api_version: 'v2',
                access_token: 'abcd',
                organization_id: 2
              }

      client = Validic::Client.new(opts)

      expect(client.api_url).to eq 'http://test.example.com'
      expect(client.api_version).to eq 'v2'
      expect(client.access_token).to eq 'abcd'
      expect(client.organization_id).to eq 2
    end

    it 'options uses defaults' do
      client = Validic::Client.new({})

      expect(client.api_url).to eq 'https://api.validic.com'
      expect(client.api_version).to eq 'v1'
    end
  end

  describe '#connection' do
    let(:client) { Validic::Client.new }

    it 'returns a Faraday::Connection object' do
      expect(client.connection).to be_kind_of Faraday::Connection
    end

    it 'has SSL enabled' do
      expect(client.connection.ssl.verify).to be true
    end
  end
end
