require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AddressBook" do
  context "implementation" do
    it "should return an array" do
      AddressBook.fetch.should be_an(Array)
    end
  end
  
  context "being used" do 
    it "should fetch addresses around Paris" do
      AddressBook.fetch.should have_at_least(1).item
    end
  end
end
