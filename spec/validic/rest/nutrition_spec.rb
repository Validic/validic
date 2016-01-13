# encoding: utf-8
require 'spec_helper'

describe Validic::REST::Nutrition do
  let(:client) { Validic::Client.new }

  describe "#get_nutritions" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/nutrition.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('nutritions.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
          @nutrition = client.get_nutrition
      end
      it 'returns a validic response object' do
        expect(@nutrition).to be_a Validic::Response
      end
      it 'makes a nutrition request to the correct url' do
        expect(a_get('/organizations/1/nutrition.json')
          .with(query: { access_token: '1', organization_id: '1' }))
          .to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/nutrition.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('bulk_nutritions.json'),
        headers: { content_type: 'application/json; charset=utf-8' })

          @nutrition = client.get_nutrition(user_id: '1')
      end
      it 'returns a Response' do
        expect(@nutrition).to be_a Validic::Response
      end
      it 'makes a nutrition request to the correct url' do
        expect(a_get('/organizations/1/users/1/nutrition.json')
          .with(query: { access_token: '1', organization_id: '1' }))
          .to have_been_made
      end
    end
  end

  describe '#create_nutrition' do
    context 'standard data'do
      before do
        stub_post("/organizations/1/users/1/nutrition.json")
          .with(body: { nutrition: { timestamp: '2013-03-10T07:12:16+00:00',
                                     activity_id: '12345' },
                        access_token: '1',
                        organization_id: '1'}.to_json)
          .to_return(body: fixture('nutrition.json'),
        headers: { content_type: 'application/json; charset=utf-8'} )
      end
      it 'requests the correct resource' do
        client.create_nutrition(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00',
                                activity_id: '12345')
        expect(a_post('/organizations/1/users/1/nutrition.json')
          .with(body: { nutrition: { timestamp: '2013-03-10T07:12:16+00:00',
        activity_id: '12345' },
        access_token: '1', organization_id: '1' }.to_json)).to have_been_made
      end
      it 'returns a Nutrition' do
        nutrition = client.create_nutrition(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00',
                                            activity_id: '12345')
        expect(nutrition).to be_a Validic::Nutrition
        expect(nutrition.timestamp).to eq '2013-03-10T07:12:16+00:00'
      end
    end
  end

  describe "#update_nutrition" do
    context 'standard data' do
      before do
        stub_put("/organizations/1/users/1/nutrition/51552cddfded0807c4000096.json")
          .with(body: { nutrition: { timestamp: '2013-03-10T07:12:16+00:00' },
                access_token: '1',
                organization_id: '1' }.to_json)
          .to_return(body: fixture('nutrition.json'),
        headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'makes a nutrition request to the correct url' do
        client.update_nutrition(user_id: '1', _id: '51552cddfded0807c4000096',
                                timestamp: '2013-03-10T07:12:16+00:00')
        expect(a_put('/organizations/1/users/1/nutrition/51552cddfded0807c4000096.json')
          .with(body: { nutrition: { timestamp: '2013-03-10T07:12:16+00:00' },
                access_token: '1',
                organization_id: '1' }.to_json)).to have_been_made
      end
      it 'returns a Nutrition' do
        nutrition = client.update_nutrition(user_id: '1', _id: '51552cddfded0807c4000096',
                                            timestamp: '2013-03-10T07:12:16+00:00')
        expect(nutrition).to be_a Validic::Nutrition
      end
    end
  end

  describe '#delete_nutrition' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/nutrition/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        nutrition = client.delete_nutrition(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(nutrition).to be true
      end
    end
  end

  describe '#latest_nutrition' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/nutrition/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('nutritions.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for nutrition' do
        latest = client.latest_nutrition(user_id: '2')
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_nutrition(user_id: '2')
        expect(a_get('/organizations/1/users/2/nutrition/latest.json')
          .with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/nutrition/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('nutritions.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for nutrition' do
        latest = client.latest_nutrition
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_nutrition
        expect(a_get('/organizations/1/nutrition/latest.json')
          .with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end
end
