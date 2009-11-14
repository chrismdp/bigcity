require File.dirname(__FILE__) + "/../spec_helper"

describe "Google::ContactRepository" do
  before do
    @gsc = Google::ContactRepository.new(mock(:token), "example.com")
  end


  context "replacing contacts on the server" do
    it "deletes contacts before creating new ones" do
      contacts = mock(:contacts)
      @gsc.should_receive(:delete_all)
      @gsc.should_receive(:create_all).with(contacts).and_return(true)
      @gsc.replace_with(contacts).should == true
    end
  end

  context "deleting all contacts on the server" do
    it "retrieves the full contact list" do
      @gsc.should_receive(:retrieve_all).and_return([])
      @gsc.delete_all
    end

    it "deletes the contacts one by one" do
      contacts = (1..10).collect do
        contact = mock(:contact)
        contact.should_receive(:delete!)
        contact
      end
      @gsc.stub!(:retrieve_all).and_return(contacts)
      @gsc.delete_all
    end
  end

  context "retrieving contacts" do
    it "asks google for the contact list" do
      FakeWeb.register_uri(:get, Google::ContactRepository::URLS[:retrieve_all] % 'example.com', :body => File.read("fixtures/contact_list.xml"))
      @gsc.retrieve_all.first[:email].should == "chris2@example.com"
    end
  end

  context "creating contacts from an external list" do
  end

end


