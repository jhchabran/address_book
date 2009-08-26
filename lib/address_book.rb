require 'rubygems'

require 'address_book/google'

module AddressBook
  def self.fetch(opts={})
    Google.new(default_options.merge(opts)).fetch
  end
  
  def self.default_options
    {
      :queries => ['Hostel Paris France', 'Restaurant Paris France', 'Coffee Paris France'],
      :referer => 'localhost:3000',
      :min => 0, 
      :max => 0,
    }
  end
  
  #p fetch(:query => 'hostel 75014 france', :min => 50)
end