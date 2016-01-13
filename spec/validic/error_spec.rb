require 'spec_helper'

describe Validic::Error do
  let(:client) { Validic::Client.new }

  context 'not found' do
    %w(weight nutrition biometrics diabetes tobacco_cessation routine fitness weight).each do |activity|
      before do
        stub_get("/organizations/1/users/0/#{activity}.json")
          .with(query: { access_token: '1', organization_id: '1' })
          .to_return(status: 404, body: fixture('not_found.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'raises a NotFound error' do
        expect { client.send("get_#{activity}", user_id: '0') }.to raise_error(Validic::Error::NotFound)
      end
    end
  end

  context 'forbidden' do
    before do
      stub_get("/organizations/0.json")
        .with(query: { access_token: '0', organization_id: '0' })
        .to_return(status: 403, body: fixture('forbidden.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'raises a Forbidden error' do
      expect { client.get_organization(organization_id: '0', access_token: '0') }.to raise_error(Validic::Error::Forbidden)
    end
  end

  context 'unprocessable entity' do
    before do
      stub_post("/organizations/1/users/1/nutrition.json")
        .with(body: { nutrition: {}, access_token: '1', organization_id: '1' })
        .to_return(status: 422, body: fixture('unprocessable_entity.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'raises an UnprocessableEntity error' do
      expect { client.create_nutrition(user_id: '1') }.to raise_error(Validic::Error::UnprocessableEntity)
    end
  end

  context 'conflict' do
    before do
      stub_post("/organizations/1/users.json")
        .with(body: { user: { uid: '123' }, access_token: '1', organization_id: '1'}.to_json)
        .to_return(status: 409, body: fixture('conflict.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'raises a Conflict error' do
      expect { client.provision_user(uid: '123') }.to raise_error(Validic::Error::Conflict)
    end
  end

  context 'internal server error' do
    before do
      stub_post("/organizations/1/users.json")
        .with(body: { user: '123', access_token: '1', organization_id: '1'}.to_json)
        .to_return(status: 500, body: fixture('internal_server.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'raises a Conflict error' do
      expect { client.provision_user('123') }.to raise_error(Validic::Error::InternalServerError)
    end
  end

  context 'unauthorized' do
    before do
      stub_get("/profile.json")
        .with(query: { access_token: '1', organization_id: '1' })
        .to_return(status: 401, body: fixture('unauthorized.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'raises a Conflict error' do
      expect { client.get_profile }.to raise_error(Validic::Error::Unauthorized)
    end
  end

  context 'Invalid date' do
    before do
      stub_request(:get, /fitness/)
        .to_return(status: 406, body: fixture('invalid_date.json'),
                   headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'raises an InvalidDate error' do
      start_date = DateTime.new(2015, 07, 15, 12)
      end_date = DateTime.new(2015, 07, 15, 13)

      expect {
        client.get_fitness(start_date: start_date, end_date: end_date)
      }.to raise_error Validic::Error::InvalidDate
    end
  end
end
