require File.dirname(__FILE__) + "/spec_helper"

describe "BigCity" do
  before(:each) do
    @googlesharedcontacts = mock(:googlesharedcontacts)
    @bigcity = BigCity.new(mock(:key), @googlesharedcontacts)
  end
  context "getting people" do
    it "gets them successfully when passed a correct key" do
      people = mock(:people)
      Highrise::Person.stub!(:find_all_across_pages).and_return(people)
      @bigcity.contacts.should == people
    end

    it "does not connect when passed a duff key" do
      Highrise::Person.stub!(:find_all_across_pages).and_raise
      lambda { @bigcity.contacts }.should raise_error
    end
  end
  context "posting shared contacts to google" do
    it "posts them successfully" do
      contacts = mock(:contacts)
      @googlesharedcontacts.should_receive(:replace_with).with(contacts).and_return(true)
      @bigcity.replace_with(contacts).should == true
    end
  end
end
