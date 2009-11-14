require File.dirname(__FILE__) + "/../spec_helper"

describe "Google::Contact" do
  context "intialization" do
    it "stores a given hash" do
      stuff = mock(:stuff)
      contact = Google::Contact.new(:id => stuff)
      contact[:id].should == stuff
    end
  end
  context "deletion" do
    it "calls google to delete itself" do
      url = "http://google.com/google"
      contact = Google::Contact.new(:edit_url => url)
      FakeWeb.register_uri(:delete, url, :body => "")
      contact.delete!.should == true
    end
  end
end
