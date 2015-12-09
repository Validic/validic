require 'spec_helper'

describe Validic::REST::Profile do
  let(:client) { Validic::Client.new }

  describe '#get_profile' do
    before do
      stub_get("/profile.json")
        .with(query: { access_token: '1', authentication_token: '2', organization_id: '1' })
        .to_return(body: fixture('profile.json'),
      headers: { content_type: 'application/json; charset=utf-8' })

        @profile = client.get_profile(authentication_token: '2')
    end
    it 'returns a validic profile object' do
      expect(@profile).to be_a Validic::Profile
    end
    it 'builds the correct path for profile' do
      expect(a_get('/profile.json')
        .with(query: { access_token: '1', authentication_token: '2', organization_id: '1' }))
        .to have_been_made
    end
  end

  describe '#create_profile' do
    before do
      stub_post("/profile.json")
        .with(
      body: { authentication_token: '2',
              profile: { gender: "m", location: "NC" },
              access_token: '1',
              organization_id: '1'}.to_json)
        .to_return(body: fixture('profile.json'),
      headers: { content_type: 'application/json; charset=utf-8' })
        @profile = client.create_profile(authentication_token: '2', gender: 'm', location: 'NC')
    end
    it 'returns a validic profile object' do
      expect(@profile).to be_a Validic::Profile
    end
    it 'builds the correct path for profile' do
      expect(a_post('/profile.json')
        .with(body: { authentication_token: '2',
                      profile: { gender: "m", location: "NC" },
                      access_token: '1',
                      organization_id: '1'
                    }
        .to_json)).to have_been_made
    end
  end
end
