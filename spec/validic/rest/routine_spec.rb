require 'spec_helper'

describe Validic::REST::Routine do
  let(:client) { Validic::Client.new }

  describe "#get_routine" do
    context 'no user_id given' do
      before do
        stub_get('/organizations/1/routine.json')
          .with(query: { access_token: '1' })
          .to_return(body: fixture('routines.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        routine = client.get_routine
        expect(routine).to be_a Validic::Response
      end
      it 'makes a routine request to the correct url' do
        client.get_routine
        expect(a_get('/organizations/1/routine.json').with(query: { access_token: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get('/organizations/1/users/1/routine.json')
          .with(query: { access_token: '1' })
          .to_return(body: fixture('routines.json'), headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        routine = client.get_routine(user_id: '1')
        expect(routine).to be_a Validic::Response
      end
      it 'makes a routine request to the correct url' do
        client.get_routine(user_id: '1')
        expect(a_get('/organizations/1/users/1/routine.json').with(query: { access_token: '1' })).to have_been_made
      end
    end
    context 'paginated true' do
      before do
        stub_get("/organizations/1/routine.json")
          .with(query: { access_token: '1', paginated: "true" })
          .to_return(body: fixture('routines.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Validic Response' do
        routine_records = client.get_routine(access_token: '1', paginated: "true")
        expect(routine_records).to be_a Validic::Response
        expect(routine_records.summary.limit).to eq 2_000
      end
    end
  end

  describe '#create_routine' do
    before do
      stub_post("/organizations/1/users/1/routine.json")
        .with(body: { routine: { timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345' },
                      access_token: '1' }.to_json)
        .to_return(body: fixture('routine.json'),
          headers: { content_type: 'application/json; charset=utf-8'} )
    end
    it 'requests the correct resource' do
      client.create_routine(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(a_post('/organizations/1/users/1/routine.json')
        .with(body: { routine: { timestamp: '2013-03-10T07:12:16+00:00',
                                   activity_id: '12345' },
                      access_token: '1' }.to_json)).to have_been_made
    end
    it 'returns a routine' do
      routine = client.create_routine(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(routine).to be_a Validic::Routine
      expect(routine.timestamp).to eq '2013-03-10T07:12:16+00:00'
    end
  end

  describe "#update_routine" do
    before do
      stub_put("/organizations/1/users/1/routine/51552cddfded0807c4000096.json")
        .with(body: { routine: { timestamp: '2013-03-10T07:12:16+00:00' },
                                   access_token: '1' }.to_json)
        .to_return(body: fixture('routine.json'),
                   headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'makes a routine request to the correct url' do
      client.update_routine(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(a_put('/organizations/1/users/1/routine/51552cddfded0807c4000096.json')
        .with(body: { routine: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1' }.to_json)).to have_been_made
    end
    it 'returns a routine' do
      routine = client.update_routine(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(routine).to be_a Validic::Routine
    end
  end

  describe '#delete_routine' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/routine/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        routine = client.delete_routine(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(routine).to be true
      end
    end
  end

  describe '#latest_routine' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/routine/latest.json").
          with(query: { access_token: '1' }).
          to_return(body: fixture('routines.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for routine' do
        latest = client.latest_routine(user_id: '2')
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_routine(user_id: '2')
        expect(a_get('/organizations/1/users/2/routine/latest.json').with(query: { access_token: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/routine/latest.json").
          with(query: { access_token: '1' }).
          to_return(body: fixture('routines.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for routine' do
        latest = client.latest_routine
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_routine
        expect(a_get('/organizations/1/routine/latest.json').with(query: { access_token: '1' })).to have_been_made
      end
    end
  end
end
