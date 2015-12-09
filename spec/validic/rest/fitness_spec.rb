# encoding: utf-8
require 'spec_helper'

describe Validic::REST::Fitness do
  let(:client) { Validic::Client.new }

  describe "#get_fitness" do
    context 'no user_id given' do
      before do
        stub_get("/organizations/1/fitness.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('fitnesses.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a validic response object' do
        fitness = client.get_fitness
        expect(fitness).to be_a Validic::Response
      end
      it 'makes a fitness request to the correct url' do
        client.get_fitness
        expect(a_get('/organizations/1/fitness.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/1/fitness.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(body: fixture('bulk_fitnesses.json'),
        headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'returns a Response' do
        fitness = client.get_fitness(user_id: '1')
        expect(fitness).to be_a Validic::Response
      end
      it 'makes a fitness request to the correct url' do
        client.get_fitness(user_id: '1')
        expect(a_get('/organizations/1/users/1/fitness.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end

  describe '#create_fitness' do
    before do
      stub_post("/organizations/1/users/1/fitness.json")
        .with(body: { fitness: { timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345' },
                      access_token: '1', organization_id: '1' }.to_json)
        .to_return(body: fixture('fitness.json'),
          headers: { content_type: 'application/json; charset=utf-8'} )
    end
    it 'requests the correct resource' do
      client.create_fitness(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(a_post('/organizations/1/users/1/fitness.json')
        .with(body: { fitness: { timestamp: '2013-03-10T07:12:16+00:00',
                                 activity_id: '12345' },
                                 access_token: '1',
                                 organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a Fitness' do
      fitness = client.create_fitness(user_id: '1', timestamp: '2013-03-10T07:12:16+00:00', activity_id: '12345')
      expect(fitness).to be_a Validic::Fitness
      expect(fitness.timestamp).to eq '2013-03-10T07:12:16+00:00'
    end
  end

  describe "#update_fitness" do
    before do
      stub_put("/organizations/1/users/1/fitness/51552cddfded0807c4000096.json")
        .with(body: { fitness: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)
        .to_return(body: fixture('fitness.json'),
                   headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'makes a fitness request to the correct url' do
      client.update_fitness(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(a_put('/organizations/1/users/1/fitness/51552cddfded0807c4000096.json')
        .with(body: { fitness: { timestamp: '2013-03-10T07:12:16+00:00' },
                      access_token: '1',
                      organization_id: '1' }.to_json)).to have_been_made
    end
    it 'returns a Fitness' do
      fitness = client.update_fitness(user_id: '1', _id: '51552cddfded0807c4000096', timestamp: '2013-03-10T07:12:16+00:00')
      expect(fitness).to be_a Validic::Fitness
    end
  end

  describe '#delete_fitness' do
    context 'when resource is found' do
      before do
        stub_delete("/organizations/1/users/1/fitness/51552cddfded0807c4000096.json")
          .to_return(status: 200)
      end
      it 'returns true' do
        fitness = client.delete_fitness(user_id: '1', _id: '51552cddfded0807c4000096')
        expect(fitness).to be true
      end
    end
  end

  describe '#latests_fitness' do
    context 'with user_id' do
      before do
        stub_get("/organizations/1/users/2/fitness/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('fitnesses.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for fitness' do
        latest = client.latest_fitness(user_id: '2')
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_fitness(user_id: '2')
        expect(a_get('/organizations/1/users/2/fitness/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
    context 'without user_id' do
      before do
        stub_get("/organizations/1/fitness/latest.json").
          with(query: { access_token: '1', organization_id: '1' }).
          to_return(body: fixture('fitnesses.json'),
                    headers: { content_type: 'application/json; charset=utf-8' })
      end
      it 'makes a latest for fitness' do
        latest = client.latest_fitness
        expect(latest).to be_a Validic::Response
      end
      it 'builds a latest url' do
        client.latest_fitness
        expect(a_get('/organizations/1/fitness/latest.json').with(query: { access_token: '1', organization_id: '1' })).to have_been_made
      end
    end
  end
end
