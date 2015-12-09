require 'spec_helper'

describe Validic::REST::Apps do
  let(:client) { Validic::Client.new }

  describe "#get_apps" do
    context 'non-expanded' do
      before do
        stub_get("/organizations/1/apps.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('apps.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
          @apps = client.get_org_apps
      end

      it 'returns a response object' do
        expect(@apps).to be_a Validic::Response
      end
      it 'makes an apps request to the correct url' do
        expect(a_get('/organizations/1/apps.json')
          .with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'expanded' do
      before do
        stub_get("/organizations/1/apps.json")
          .with(query: { access_token: '1', expanded: 1, organization_id: '1' })
          .to_return(body: fixture('apps.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
          @apps = client.get_org_apps(expanded: 1)
      end
      it 'returns a response object' do
        expect(@apps).to be_a Validic::Response
      end
      it 'makes an apps request to the correct url' do
        expect(a_get('/organizations/1/apps.json')
          .with(query: { access_token: '1', expanded: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#get_user_synced_apps' do
    before do
      stub_get('/organizations/1/sync_apps.json')
        .with(query: { authentication_token: '2', access_token: '1', organization_id: '1' })
        .to_return(body: fixture('synced_apps.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
        @synced_apps = client.get_user_synced_apps(authentication_token: '2')
    end
    it 'returns a response object' do
      expect(@synced_apps).to be_a Validic::Response
    end
    it 'makes a sync apps call to the correct url' do
      expect(a_get('/organizations/1/sync_apps.json')
        .with(query: { authentication_token: '2', access_token: '1', organization_id: '1' }))
        .to have_been_made
    end
  end

end
