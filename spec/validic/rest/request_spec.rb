require 'spec_helper'

describe Validic::REST::Request do
  let(:client) { Validic::Client.new }

  describe "#pull_via_url" do
    before do
      stub_get('/organizations/1/routine.json')
        .with(query: { access_token: '1' })
        .to_return(body: fixture('routines.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
      stub_get('/organizations/1/routine.json')
        .with(query: { access_token: '1', page: '2', start_date: '2013-01-01' })
        .to_return(body: fixture('routines_page2.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
    end
    it "returns data using the next value of the summary response" do
      routine = client.get_routine
      expect(routine).to be_a Validic::Response
      pull_next = client.pull_via_url routine.summary.next
      expect(pull_next).to be_a Validic::Response
      expect(pull_next.records).to be_kind_of Array
    end
  end
end
