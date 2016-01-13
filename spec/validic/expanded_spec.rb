require 'spec_helper'

describe 'expanded for all objects' do
  let(:client) { Validic::Client.new }
  objects = ['nutrition', 'fitness', 'routine', 'sleep', 'weight', 'diabetes',
             'biometrics', 'tobacco_cessation']

  objects.each do |object|
    context "#create #{object}" do
      before do
        #set up stub request for a create call with extras
        stub_post("/organizations/1/users/1/#{object}.json")
          .with(body: { object.to_sym => { timestamp: '2013-03-10T07:12:16+00:00',
        activity_id: '12345', extras: "{\"stars\": 3}" }, access_token: '1',
        organization_id: '1' }.to_json)
          .to_return(body: fixture("#{object}-extras.json"),
        headers: { content_type: 'application/json; charset=utf-8'} )

          #use the create_object method
          @obj = client.send("create_#{object}", user_id: '1', timestamp: '2013-03-10T07:12:16+00:00',
                             activity_id: '12345',
                             extras: "{\"stars\": 3}")
      end
      it 'renders correct path' do
        expect(a_post("/organizations/1/users/1/#{object}.json")
          .with(body: { object.to_sym => { timestamp: '2013-03-10T07:12:16+00:00',
        activity_id: '12345', extras: "{\"stars\": 3}"},
          access_token: '1', organization_id: '1' }.to_json)).to have_been_made
      end
      it 'creates the correct object' do
        klass = Validic.const_get(camelize_response_key(object))
        expect(@obj).to be_a klass
        expect(@obj.timestamp).to eq '2013-03-10T07:12:16+00:00'
      end
    end
    context "#update #{object}" do
      before do
        stub_put("/organizations/1/users/1/#{object}/51552cddfded0807c4000096.json")
          .with(body: { object.to_sym => { timestamp: '2013-03-10T07:12:16+00:00',
        extras: "{\"stars\": 3}"}, access_token: '1', organization_id: '1' }.to_json)
          .to_return(body: fixture("#{object}-extras.json"),
        headers: { content_type: 'application/json; charset=utf-8'} )
          @obj = client.send("update_#{object}", user_id: '1', _id: "51552cddfded0807c4000096",
                                               timestamp: '2013-03-10T07:12:16+00:00',
                                               extras: "{\"stars\": 3}")
      end
      it 'requests the correct resource' do
        expect(a_put("/organizations/1/users/1/#{object}/51552cddfded0807c4000096.json")
          .with(body: { object.to_sym => { timestamp: '2013-03-10T07:12:16+00:00',
        extras: "{\"stars\": 3}"},
          access_token: '1', organization_id: '1' }.to_json)).to have_been_made
      end
      it 'returns an object' do
        klass = Validic.const_get(camelize_response_key(object))
        expect(@obj).to be_a klass
        expect(@obj.timestamp).to eq '2013-03-10T07:12:16+00:00'
      end
    end
    context "#get #{object}" do
      before do
        stub_get("/organizations/1/#{object}.json")
          .with(query: { access_token: '1', expanded: '1', organization_id: '1' })
          .to_return(body: fixture("#{object}-expanded.json"),
        headers: { content_type: 'application/json; charset=utf-8' })

          @obj = client.send("get_#{object}", expanded: '1')
      end
      it 'returns a validic response' do
        expect(@obj).to be_a Validic::Response
      end
      it 'makes an object URI request with expanded' do
        expect(a_get("/organizations/1/#{object}.json")
          .with(query: { access_token: '1', expanded: '1', organization_id: '1' }))
          .to have_been_made
      end
    end

  end
end


def camelize_response_key(str)
  key = str
  key = key.include?('_') ? key.split('_').map(&:capitalize).join : key.capitalize
  key.chop! if %w(Users Apps).include?(key) #strip last letter off to match ::User or ::App
  key
end
