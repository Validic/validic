# encoding: utf-8
require 'spec_helper'

describe Validic::REST::Diabetes do
  let(:client) { Validic::Client.new }

  describe "#get_diabetes" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/diabetes.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('diabetes_records.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        diabetes_record = client.get_diabetes
        expect(diabetes_record).to be_a Validic::Response
      end
      it 'makes a diabetes request to the correct url' do
        client.get_diabetes
        expect(a_get('/organizations/1/diabetes.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/diabetes.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('bulk_diabetes_records.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        diabetes_record = client.get_diabetes(user_id: '1')
        expect(diabetes_record).to be_a Validic::Response
      end
      it 'makes a diabetes request to the correct url' do
        client.get_diabetes(user_id: '1')
        expect(a_get('/organizations/1/users/1/diabetes.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#create_diabetes' do
    before do
      stub_post("/organizations/1/users/1/diabetes.json")
        .with(body: { diabetes: { timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345' },
                      access_token: '1',
                      organization_id: '1' }.to_json)
        .to_return(body: fixture('diabetes_record.json'),
          headers: { content_type: 'application/json; charset=utf-8'} )
    end
    it 'requests the correct resource' do
      client.create_diabetes(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(a_post('/organizations/1/users/1/diabetes.json')
        .with(body: { diabetes: { timestamp: '2013-03-10T07:12:16+00:00',
                                  activity_id: '12345' },
                      access_token: '1',
                      organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a Diabetes' do
      diabetes_record = client.create_diabetes(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(diabetes_record).to be_a Validic::Diabetes
      expect(diabetes_record.timestamp).to eq '2013-03-10T07:12:16+00:00'
    end
  end

  describe "#update_diabetes" do
    before do
      stub_put("/organizations/1/users/1/diabetes/51552cddfded0807c4000096.json")
        .with(body: { diabetes: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)
        .to_return(body: fixture('diabetes_record.json'),
                   headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'makes a diabetes request to the correct url' do
      client.update_diabetes(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(a_put('/organizations/1/users/1/diabetes/51552cddfded0807c4000096.json')
        .with(body: { diabetes: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a Diabetes' do
      diabetes_record = client.update_diabetes(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(diabetes_record).to be_a Validic::Diabetes
    end
  end

  describe '#delete_diabetes' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/diabetes/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        diabetes_record = client.delete_diabetes(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(diabetes_record).to be true
      end
    end
  end

  describe '#latest_diabetes' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/diabetes/latest.json").
          with(query: { access_token: '1',organization_id: '1' }).
          to_return(body: fixture('diabetes_records.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for diabetes' do
        latest = client.latest_diabetes(user_id: '2')
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_diabetes(user_id: '2')
        expect(a_get('/organizations/1/users/2/diabetes/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/diabetes/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('diabetes_records.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a request for latest diabetes records' do
        latest = client.latest_diabetes
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_diabetes
        expect(a_get('/organizations/1/diabetes/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end
end
