require 'rubygems'
require 'net/http'
require 'json'

module AddressBook
  class Google
    HOST = "ajax.googleapis.com"
    SERVICE_PATH = "/ajax/services/search/local"
    PARAMETERS = "?v=1.0&q="
    
    def initialize(opts)
      @opts = opts
    end
    
    def fetch
      Net::HTTP.start HOST do |http|
        response = http.request_get(build_url, 'Referer' => @opts[:referer])
        # add some errors handling here
        parse(response)
      end
    end
    
    private
    def build_url
      @url ||= SERVICE_PATH + PARAMETERS + @opts[:query]
    end
    
    # TODO, add some code 
    def parse(response)
      json = JSON.parse(response.body)
      if json['responseData']['results'] 
        json['responseData']['results'].collect do |result|
          result['addressLines'].to_s
        end
      else
        nil
      end
    end
    
  end
end

