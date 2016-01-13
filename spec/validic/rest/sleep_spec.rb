require 'spec_helper'

describe Validic::REST::Sleep do
  let(:client) { Validic::Client.new }

  describe "#get_sleeps" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/sleep.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('sleeps.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        sleep = client.get_sleep
        expect(sleep).to be_a Validic::Response
      end
      it 'makes a sleep request to the correct url' do
        client.get_sleep
        expect(a_get('/organizations/1/sleep.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/sleep.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('bulk_sleeps.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        sleep = client.get_sleep(user_id: '1')
        expect(sleep).to be_a Validic::Response
      end
      it 'makes a sleep request to the correct url' do
        client.get_sleep(user_id: '1')
        expect(a_get('/organizations/1/users/1/sleep.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#create_sleep' do
    before do
      stub_post("/organizations/1/users/1/sleep.json").
        with(body: { sleep: { timestamp: '2013-03-10T07:12:16+00:00',
                              utc_offset: '+00:00', total_sleep: 477,
                              awake: 34, deep: 234, light: 94, rem: 115,
                              times_woken: 4, activity_id: '12345' },
                              access_token: '1', organization_id: '1' }.to_json).
                              to_return(body: fixture('sleep.json'),
                                        headers: { content_type: 'application/json; charset=utf-8'} )
    end
    it 'returns a Sleep' do
      @sleep = client.create_sleep(user_id: '1', timestamp: "2013-03-10T07:12:16+00:00",
                                   utc_offset: "+00:00",
                                   total_sleep: 477,
                                   awake: 34,
                                   deep: 234,
                                   light: 94,
                                   rem: 115,
                                   times_woken: 4,
                                   activity_id: '12345')

      expect(@sleep).to be_a Validic::Sleep
      expect(@sleep.total_sleep).to eq 477
    end
  end

  describe "#update_sleep" do
    before do
      stub_put("/organizations/1/users/1/sleep/51552cddfded0807c4000096.json").
        with(body: { sleep: { timestamp: '2013-03-10T07:12:16+00:00',
                              utc_offset: '+00:00', total_sleep: 477,
                              awake: 224, deep: 234, light: 94, rem: 115,
                              times_woken: 4 },
                              access_token: '1',
                              organization_id: '1' }.to_json).
                              to_return(body: fixture('sleep.json'),
                                        headers: {content_type: 'application/json; charset=utf-8'})

                              @sleep = client.update_sleep(user_id: '1',
                                                           _id: "51552cddfded0807c4000096",
                                                           timestamp: "2013-03-10T07:12:16+00:00",
                                                           utc_offset: "+00:00",
                                                           total_sleep: 477,
                                                           awake: 224,
                                                           deep: 234,
                                                           light: 94,
                                                           rem: 115,
                                                           times_woken: 4)
    end

    it 'returns a sleep object' do
      expect(@sleep).to be_a Validic::Sleep
    end

    it 'makes a sleep request to the correct url' do
      url = "#{Validic::BASE_URL}/organizations/1/users/1/sleep/51552cddfded0807c4000096.json"
      expect(a_request(:put, url)).to have_been_made
    end
  end

  describe '#delete_sleep' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/sleep/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        sleep = client.delete_sleep(user_id: '1',
                                    _id: '51552cddfded0807c4000096')
        expect(sleep).to be true
      end
    end
  end

  describe '#latest_sleep' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/sleep/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('sleeps.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
          @latest = client.latest_sleep(user_id: '2')
      end
      it 'makes a latest for sleep' do
        expect(@latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        expect(a_get('/organizations/1/users/2/sleep/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/sleep/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('sleeps.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
          @latest = client.latest_sleep
      end
      it 'makes a latest for sleep' do
        expect(@latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        expect(a_get('/organizations/1/sleep/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

end
