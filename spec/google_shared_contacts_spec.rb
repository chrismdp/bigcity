require File.dirname(__FILE__) + "/spec_helper"

describe "Google Shared Contacts" do
  before do
    FakeWeb.register_uri(:post, GoogleSharedContacts::URLS[:client_login], :body => "")
    @gsc = GoogleSharedContacts.new(mock(:username), mock(:password), "example.com")
  end

  context "initialization" do
    it "accepts a username/password" do
      GoogleSharedContacts.new(mock(:username), mock(:password), mock(:domain))
    end
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
    xit "asks google for the contact list" do
      contacts = GoogleSharedContacts::ContactList.new
      contacts << GoogleSharedContacts::Contact.new(:email => 'chris1@eden.com')
      FakeWeb.register_uri(:get, GoogleSharedContacts::URLS[:retrieve_all] % 'example.com', :body => contacts.to_atom)
      @gsc.retrieve_all.first[:email].should == "chris1@eden.com"
    end
  end

  context "creating contacts from an external list" do
  end

  context "ContactList" do
    context "initialization" do
      it "works without parameters creating an empty list" do
        GoogleSharedContacts::ContactList.new.size == 0
      end
      context "with atom xml" do
        before do
          GoogleSharedContacts::Contact.stub!(:new).and_return(mock(:contact))
        end

        it "creates multiple contacts" do
          list = GoogleSharedContacts::ContactList.new(File.read("fixtures/contact_list.xml"))
          list.size.should == 2
        end
        it "loads contacts with ids" do
          GoogleSharedContacts::Contact.should_receive(:new).with(hash_including(:id)).and_return(mock(:contact))
          list = GoogleSharedContacts::ContactList.new(File.read("fixtures/contact_list.xml"))
        end
        it "loads contacts with the last updated time" do
          GoogleSharedContacts::Contact.should_receive(:new).with(
            hash_including(:updated_at => Time.parse("2008-03-05T12:36:38.835Z"))).and_return(mock(:contact))
          list = GoogleSharedContacts::ContactList.new(File.read("fixtures/contact_list.xml"))
        end
        it "loads contacts with the email field" do
          GoogleSharedContacts::Contact.should_receive(:new).with(
            hash_including(:email)).and_return(mock(:contact))
          list = GoogleSharedContacts::ContactList.new(File.read("fixtures/contact_list.xml"))
        end
      end
    end
  end

end


