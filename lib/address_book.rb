require 'rubygems'

require 'address_book/google'

module AddressBook
  def self.fetch(opts=default_options)
    Google.new(opts).fetch
  end
  
  def self.default_options
    {
      :query => 'Hostel%20Paris',
      :max => 5,
      :referer => 'localhost:3000'
    }
  end
end