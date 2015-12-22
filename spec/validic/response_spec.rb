require 'spec_helper'

describe Validic::Response do
  let(:client) { Validic::Client.new }

  describe "Validic::Response next/previous" do
    before do
      stub_get('/organizations/1/routine.json')
        .with(query: { access_token: '1' })
        .to_return(body: fixture('routines.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
      stub_get('/organizations/1/routine.json')
        .with(query: { access_token: '1', page: '2', paginated: 'true', start_date: '2013-01-01' })
        .to_return(body: fixture('routines2.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
      stub_get('/organizations/1/routine.json')
        .with(query: { access_token: '1', page: '1', paginated: 'true', start_date: '2013-01-01'  })
        .to_return(body: fixture('routines.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
    end
    it "makes a #next call" do
      routine = client.get_routine
      expect(routine).to be_a Validic::Response

      next_call = routine.next
      expect(next_call).to be_a Validic::Response
      expect(next_call.records.size).to eq 2
    end
    it "makes a #previous call" do
      routine = client.get_routine
      expect(routine).to be_a Validic::Response
      next_call = routine.next
      previous_call = next_call.previous

      expect(previous_call).to be_a Validic::Response
      expect(previous_call.records.size).to eq 2
    end
  end
end
