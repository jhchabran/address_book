require 'rubygems'

require 'address_book/google'

module AddressBook
  def self.fetch(opts={})
    Google.new(default_options.merge(opts)).fetch
  end
  
  def self.default_options
    {
      :query => 'Hostel Paris France',
      :min => 3,
      :max => -1,
      :referer => 'localhost:3000'
    }
  end
  
end