# encoding: utf-8
require 'spec_helper'

describe Validic::REST::TobaccoCessation do
  let(:client) { Validic::Client.new }

  describe "#get_tobacco_cessation" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/tobacco_cessation.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('tobacco_cessations.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        tobacco_cessation = client.get_tobacco_cessation
        expect(tobacco_cessation).to be_a Validic::Response
      end
      it 'makes a tobacco_cessation request to the correct url' do
        client.get_tobacco_cessation
        expect(a_get('/organizations/1/tobacco_cessation.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/tobacco_cessation.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('bulk_tobacco_cessations.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        tobacco_cessation = client.get_tobacco_cessation(user_id: '1')
        expect(tobacco_cessation).to be_a Validic::Response
      end
      it 'makes a tobacco_cessation request to the correct url' do
        client.get_tobacco_cessation(user_id: '1')
        expect(a_get('/organizations/1/users/1/tobacco_cessation.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#create_tobacco_cessation' do
    before do
      stub_post("/organizations/1/users/1/tobacco_cessation.json")
        .with(body: { tobacco_cessation: { timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345' },
                      access_token: '1', organization_id: '1' }.to_json)
        .to_return(body: fixture('tobacco_cessation.json'),
          headers: { content_type: 'application/json; charset=utf-8'} )
    end
    it 'requests the correct resource' do
      client.create_tobacco_cessation(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(a_post('/organizations/1/users/1/tobacco_cessation.json')
        .with(body: { tobacco_cessation: { timestamp: '2013-03-10T07:12:16+00:00',
                                   activity_id: '12345' },
                      access_token: '1', organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a TobaccoCessation' do
      tobacco_cessation = client.create_tobacco_cessation(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(tobacco_cessation).to be_a Validic::TobaccoCessation
      expect(tobacco_cessation.timestamp).to eq '2013-03-10T07:12:16+00:00'
    end
  end

  describe "#update_tobacco_cessation" do
    before do
      stub_put("/organizations/1/users/1/tobacco_cessation/51552cddfded0807c4000096.json")
        .with(body: { tobacco_cessation: { timestamp: '2013-03-10T07:12:16+00:00' },
                                   access_token: '1', organization_id: '1' }.to_json)
        .to_return(body: fixture('tobacco_cessation.json'),
                   headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'makes a tobacco_cessation request to the correct url' do
      client.update_tobacco_cessation(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(a_put('/organizations/1/users/1/tobacco_cessation/51552cddfded0807c4000096.json')
        .with(body: { tobacco_cessation: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a TobaccoCessation' do
      tobacco_cessation = client.update_tobacco_cessation(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(tobacco_cessation).to be_a Validic::TobaccoCessation
    end
  end

  describe '#delete_tobacco_cessation' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/tobacco_cessation/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        tobacco_cessation = client.delete_tobacco_cessation(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(tobacco_cessation).to be true
      end
    end
  end

  describe '#latests_tobacco_cessation' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/tobacco_cessation/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('tobacco_cessations.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for tobacco_cessation' do
        latest = client.latest_tobacco_cessation(user_id: '2')
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_tobacco_cessation(user_id: '2')
        expect(a_get('/organizations/1/users/2/tobacco_cessation/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/tobacco_cessation/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('tobacco_cessations.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for tobacco_cessation' do
        latest = client.latest_tobacco_cessation
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_tobacco_cessation
        expect(a_get('/organizations/1/tobacco_cessation/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end
end
