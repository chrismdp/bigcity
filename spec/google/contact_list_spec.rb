require File.dirname(__FILE__) + "/../spec_helper"

describe "Google::ContactList" do
  context "initialization" do
    it "works without parameters creating an empty list" do
      Google::ContactList.new.size == 0
    end
    context "with atom xml" do
      before do
        Google::Contact.stub!(:new).and_return(mock(:contact))
      end
      def list_from_atom_xml
        Google::ContactList.new(File.read("fixtures/contact_list.xml"))
      end
      it "creates multiple contacts" do
        list_from_atom_xml.size.should == 2
      end
      it "loads contacts with ids" do
        Google::Contact.should_receive(:new).with(hash_including(:id)).and_return(mock(:contact))
        list_from_atom_xml
      end
      it "loads contacts with the last updated time" do
        Google::Contact.should_receive(:new).with(
          hash_including(:updated_at => Time.parse("2008-03-05T12:36:38.835Z"))).and_return(mock(:contact))
        list_from_atom_xml
      end
      it "loads contacts with the email field" do
        Google::Contact.should_receive(:new).with(
          hash_including(:email => "chris2@example.com")).and_return(mock(:contact))
        list_from_atom_xml
      end
      it "loads contact with the edit_url for deletion" do
        Google::Contact.should_receive(:new).with(
          hash_including(:edit_url => "http://www.google.com/m8/feeds/contacts/example.com/full/c9012de/1204720598835000")).and_return(mock(:contact))
        list_from_atom_xml
      end
    end
  end
end

