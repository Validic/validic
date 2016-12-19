# encoding: utf-8
require 'spec_helper'

describe Validic::User do

  let(:client) { Validic::Client.new }

  context "#get_users" do
    before do
      @users_response = client.get_users
    end

    it "returns JSON response of Validic::Organization", vcr: true do
      @users_response.should_not be_nil
    end

    it "status 200" do
      @users_response.summary.status.should == 200
    end

    it "has summary node" do
      @users_response.summary.should_not be_nil
    end

  end

  context "#me" do
    before do
      @me = client.me({})
    end

    it "returns JSON response of Validic::User", vcr: true do
      @me.should_not be_nil
    end

    it "should return the user id" do
      pending
      @me.user._id.should_not be_nil
    end
  end

  context "#user_provisioning" do
    it "should create a new user under an organization" do
      pending
      @new_user = client.user_provision(organization_id: "51aca5a06dedda916400002b",
                                        uid: "123asdfg",
                                        height: 167,
                                        weight: 69,
                                        location: "TX",
                                        gender: "M")
      @new_user.users.access_token.should_not be_nil
      @new_user.users.profile.height.should eq "167"
      @new_user.users.profile.weight.should eq 69
      @new_user.users.profile.location.should eq 'TX'
      @new_user.users.profile.gender.should eq 'M'
    end
  end

  context "#user_suspend" do
    it "should suspend a user" do
      pending
      @suspend_user = client.user_suspend(organization_id: "51aca5a06dedda916400002b",
                                          user_id: ENV['TEST_USER_ID'],
                                          access_token: "9c03ad2bcb022425944e4686d398ef8398f537c2f7c113495ffa7bc9cfa49286",
                                          suspend: 1)
      @suspend_user.message.should eq "The user has been suspended successfully"
    end
  end

  context "#user_delete" do
    it "should delete a user" do
      pending
      @delete_user = client.user_delete(organization_id: "51aca5a06dedda916400002b",
                                        uid: ENV['TEST_USER_ID'],
                                        access_token: "9c03ad2bcb022425944e4686d398ef8398f537c2f7c113495ffa7bc9cfa49286")
      @delete_user.status.should eq 200
    end
  end

end
