require File.dirname(__FILE__) + "/spec_helper"

describe "Google Shared Contacts" do
  before do
    FakeWeb.register_uri(:post, GoogleSharedContacts::URLS[:client_login] + "?", :body => "")
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
    it "asks google for the contact list" do
      FakeWeb.register_uri(:get, GoogleSharedContacts::URLS[:retrieve_all] % 'example.com', :body => File.read("fixtures/contact_list.xml"))
      @gsc.retrieve_all.first[:email].should == "chris2@example.com"
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
        def list_from_atom_xml
          GoogleSharedContacts::ContactList.new(File.read("fixtures/contact_list.xml"))
        end
        it "creates multiple contacts" do
          list_from_atom_xml.size.should == 2
        end
        it "loads contacts with ids" do
          GoogleSharedContacts::Contact.should_receive(:new).with(hash_including(:id)).and_return(mock(:contact))
          list_from_atom_xml
        end
        it "loads contacts with the last updated time" do
          GoogleSharedContacts::Contact.should_receive(:new).with(
            hash_including(:updated_at => Time.parse("2008-03-05T12:36:38.835Z"))).and_return(mock(:contact))
          list_from_atom_xml
        end
        it "loads contacts with the email field" do
          GoogleSharedContacts::Contact.should_receive(:new).with(
            hash_including(:email => "chris2@example.com")).and_return(mock(:contact))
          list_from_atom_xml
        end
        it "loads contact with the edit_url for deletion" do
          GoogleSharedContacts::Contact.should_receive(:new).with(
            hash_including(:edit_url => "http://www.google.com/m8/feeds/contacts/example.com/full/c9012de/1204720598835000")).and_return(mock(:contact))
          list_from_atom_xml
        end
      end
    end
  end

  context "Contact" do
    context "intialization" do
      it "stores a given hash" do
        stuff = mock(:stuff)
        contact = GoogleSharedContacts::Contact.new(:id => stuff)
        contact[:id].should == stuff
      end
    end
    context "deletion" do
      it "calls google to delete itself" do
        url = "http://google.com/google"
        contact = GoogleSharedContacts::Contact.new(:edit_url => url)
        FakeWeb.register_uri(:delete, url, :body => "")
        contact.delete!.should == true
      end
    end
  end
end


