require 'rubygems'

require 'address_book/google'

module AddressBook
  def self.fetch(opts={})
    Google.new(default_options.merge(opts)).fetch
  end
  
  def self.default_options
    {
      :query => 'Hostel Paris',
      :min => 3,
      :max => 5,
      :referer => 'localhost:3000'
    }
  end
end