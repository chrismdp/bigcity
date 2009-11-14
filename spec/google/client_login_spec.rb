require File.dirname(__FILE__) + "/../spec_helper"

describe "Google::ClientLogin" do
  context "authentication" do
    before do
      FakeWeb.register_uri(:post, Google::ClientLogin::URL + "?", :body => "SID=SidToken\nLSID=;lkjsf;lskfjg\nAuth=authToken123\n")
    end

    it "accepts a username and password" do
      Google::ClientLogin.authenticate(mock(:username), mock(:password))
    end

    it "returns an auth token taken from the google response" do
      Google::ClientLogin.authenticate(mock(:username), mock(:password)).should == "authToken123"
    end
  end
end
