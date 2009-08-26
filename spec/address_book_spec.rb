require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AddressBook" do
  context "implementation" do
    it "should return an array" do
      AddressBook.fetch.should be_an(Array)
    end
  end
  
  context "being used" do 
    it "should fetch addresses" do
      AddressBook.fetch.should have_at_least(1).item
    end
    
    it "should fetch at least 5 addresses" do
      AddressBook.fetch(:min => 5).should have_at_least(5).item
    end
    
    it "should fetch at most 5 addresses" do
      AddressBook.fetch(:max => 5).should have_at_most(5).item
    end
  end
end
