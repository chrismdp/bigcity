require File.dirname(__FILE__) + "/../spec_helper"

describe "Google::Contact" do
  context "intialization" do
    it "stores a given hash" do
      stuff = mock(:stuff)
      contact = Google::Contact.new(:id => stuff)
      contact[:id].should == stuff
    end
  end
  context "converting to atom" do
    it "returns an atom description" do
      contact = Google::Contact.new
      contact.to_atom.should match("<atom:entry")
    end
    it "returns the email address in a gd:email block" do
      contact = Google::Contact.new :email => { :home => "c1@g.com" }
      contact.to_atom.should match(%{<gd:email rel="http://schemas.google.com/g/2005#home" address="c1@g.com"/>})
    end
    it "returns the name in a title block" do
      contact = Google::Contact.new :title => "Charles Block"
      contact.to_atom.should match(%{<title type="text">Charles Block</title>})
    end
    it "returns the phone number in a gd:phoneNumber block" do
      contact = Google::Contact.new :phone => { :home => "12345" }
      contact.to_atom.should match(%{<gd:phoneNumber rel="http://schemas.google.com/g/2005#home">12345</gd:phoneNumber>})
    end
    it "does not return a field when it doesn't exist" do
      contact = Google::Contact.new :phone => { :home => "12345" }
      contact.to_atom.should_not match(%{<gd:email})
    end
  end
end
