# encoding: utf-8
require 'spec_helper'

describe Validic::REST::Biometrics do
  let(:client) { Validic::Client.new }

  describe "#get_biometrics" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/biometrics.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('biometrics_records.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        biometrics_record = client.get_biometrics
        expect(biometrics_record).to be_a Validic::Response
      end
      it 'makes a biometrics request to the correct url' do
        client.get_biometrics
        expect(a_get('/organizations/1/biometrics.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/biometrics.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('bulk_biometrics_records.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        biometrics_record = client.get_biometrics(user_id: '1')
        expect(biometrics_record).to be_a Validic::Response
      end
      it 'makes a biometrics request to the correct url' do
        client.get_biometrics(user_id: '1')
        expect(a_get('/organizations/1/users/1/biometrics.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#create_biometrics' do
    before do
      stub_post("/organizations/1/users/1/biometrics.json")
        .with(body: { biometrics: { timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345' },
                      access_token: '1',
                      organization_id: '1' }.to_json)
        .to_return(body: fixture('biometrics_record.json'),
          headers: { content_type: 'application/json; charset=utf-8'} )
    end
    it 'requests the correct resource' do
      client.create_biometrics(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(a_post('/organizations/1/users/1/biometrics.json')
        .with(body: { biometrics: { timestamp: '2013-03-10T07:12:16+00:00',
                                    activity_id: '12345' },
                      access_token: '1',
                      organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a Biometrics' do
      biometrics_record = client.create_biometrics(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(biometrics_record).to be_a Validic::Biometrics
      expect(biometrics_record.timestamp).to eq '2013-03-10T07:12:16+00:00'
    end
  end

  describe "#update_biometrics" do
    before do
      stub_put("/organizations/1/users/1/biometrics/51552cddfded0807c4000096.json")
        .with(body: { biometrics: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)
        .to_return(body: fixture('biometrics_record.json'),
                   headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'makes a biometrics request to the correct url' do
      client.update_biometrics(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(a_put('/organizations/1/users/1/biometrics/51552cddfded0807c4000096.json')
        .with(body: { biometrics: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a Biometrics' do
      biometrics_record = client.update_biometrics(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(biometrics_record).to be_a Validic::Biometrics
    end
  end

  describe '#delete_biometrics' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/biometrics/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        biometrics_record = client.delete_biometrics(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(biometrics_record).to be true
      end
    end
  end

  describe '#latest_biometrics' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/biometrics/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('biometrics_records.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for biometrics' do
        latest = client.latest_biometrics(user_id: '2')
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_biometrics(user_id: '2')
        expect(a_get('/organizations/1/users/2/biometrics/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/biometrics/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('biometrics_records.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a request for latest biometrics records' do
        latest = client.latest_biometrics
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_biometrics
        expect(a_get('/organizations/1/biometrics/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end
end
