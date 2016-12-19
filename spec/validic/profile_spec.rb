# encoding: utf-8
require 'spec_helper'

describe Validic::Profile do

  let(:client) { Validic::Client.new }

  context "#get_profile" do
    before do
      @profile = client.get_profile({})
    end

    it "returns JSON response of Validic::Profile", vcr: true do
      @profile.should_not be_nil
    end
  end

end
