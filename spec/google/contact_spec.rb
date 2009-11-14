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
      contact.to_atom.should match("<entry>")
    end
  end
end
