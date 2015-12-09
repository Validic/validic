require 'spec_helper'

describe Validic::REST::Weight do
  let(:client) { Validic::Client.new }

  describe "#get_weight" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/weight.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('weights.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        weight = client.get_weight
        expect(weight).to be_a Validic::Response
      end
      it 'makes a weight request to the correct url' do
        client.get_weight
        expect(a_get('/organizations/1/weight.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/weight.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('weights.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        weight = client.get_weight(user_id: '1')
        expect(weight).to be_a Validic::Response
      end
      it 'makes a weight request to the correct url' do
        client.get_weight(user_id: '1')
        expect(a_get('/organizations/1/users/1/weight.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#create_weight' do
    before do
      stub_post("/organizations/1/users/1/weight.json").
        with(body: { weight: { timestamp: '2013-03-10T07:12:16+00:00',
                               utc_offset: '+00:00', weight: 177,
                               height: 34, data_id: '12345' },
                               access_token: '1', organization_id: '1' }.to_json)
        .to_return(body: fixture('weight.json'),
      headers: { content_type: 'application/json; charset=utf-8'} )

        @weight = client.create_weight(user_id: '1',
                                       timestamp: "2013-03-10T07:12:16+00:00",
                                       utc_offset: "+00:00",
                                       weight: 177,
                                       height: 34,
                                       data_id: '12345')
    end
    it 'returns a weight' do
     expect(@weight).to be_a Validic::Weight
    end
    it 'builds the correct url' do
      pending
      expect(a_post('/organizations/1/users/1/weight.json')
          .with(body: { weight: { timestamp: '2013-03-10T07:12:16+00:00',
      utf_offset: '+00:00', weight: 177,
      height: 34, data_id: '12345'},
      access_token: '1' })).to have_been_made
    end
  end

  describe "#update_weight" do
    before do
      stub_put("/organizations/1/users/1/weight/51552cddfded0807c4000083.json").
        with(body: { weight: { timestamp: '2013-03-10T07:12:16+00:00',
                               utc_offset: '+00:00', total_weight: 377,
                               awake: 224, deep: 234, light: 94, rem: 115,
                               times_woken: 4 },
                               access_token: '1', organization_id: '1' }.to_json)
        .to_return(body: fixture('weight.json'),
      headers: {content_type: 'application/json; charset=utf-8'})

        @weight = client.update_weight(user_id: '1',
                                       _id: "51552cddfded0807c4000083",
                                       timestamp: "2013-03-10T07:12:16+00:00",
                                       utc_offset: "+00:00",
                                       total_weight: 377,
                                       awake: 224,
                                       deep: 234,
                                       light: 94,
                                       rem: 115,
                                       times_woken: 4)
    end

    it 'returns a weight' do
      expect(@weight).to be_a Validic::Weight
    end

    it 'makes a weight request to the correct url' do
      url = "#{Validic::BASE_URL}/organizations/1/users/1/weight/51552cddfded0807c4000083.json"
      expect(a_request(:put, url)).to have_been_made
    end
  end

  describe '#delete_weight' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/weight/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        weight = client.delete_weight(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(weight).to be true
      end
    end
  end

  describe '#latest_weight' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/weight/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('weights.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
          @latest = client.latest_weight(user_id: '2')
      end
      it 'makes a latest for weight' do
        expect(@latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        expect(a_get('/organizations/1/users/2/weight/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/weight/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('weights.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
          @latest = client.latest_weight
      end
      it 'makes a latest for weight' do
        expect(@latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        expect(a_get('/organizations/1/weight/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

end
