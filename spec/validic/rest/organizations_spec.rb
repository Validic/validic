require 'spec_helper'

describe Validic::REST::Organizations do
  let(:client) { Validic::Client.new }

  describe "#get_organization" do
    before do
      stub_get('/organizations/1.json')
        .with(query: { access_token: '1', organization_id: '1' })
        .to_return(body: fixture('organizations.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
      @org = client.get_organization
    end
    it 'returns an organization object' do
      expect(@org).to be_a Validic::Response
    end
    it 'creates the correct url' do
      expect(a_get('/organizations/1.json')
        .with(query: { access_token: '1', organization_id: '1' }))
        .to have_been_made
    end
  end

end
