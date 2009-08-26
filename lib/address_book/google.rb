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
      data = response['responseData']
      return unless data # will suit until some exceptions are defined to be raised here
      return unless data['results']
      
      data['results'].collect do |result|
        result['addressLines'].to_s
      end
    end
    
    private
    
    def request
      Net::HTTP.start HOST do |http|
        response = http.request_get(build_url, 'Referer' => @opts[:referer])
        # TODO add some errors handling here
        parse_json(response)
      end
    end
    
    def response
      @response ||= request
    end
    
    def more_result
      response
    end
    
    def build_url
      @url ||= SERVICE_PATH + PARAMETERS + @opts[:query]
    end
    
    def parse_json(response)
      JSON.parse(response.body)
    end
    
  end
end

