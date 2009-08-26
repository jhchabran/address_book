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
      return unless valid_response?
      data = response['responseData']
      data['results'].collect do |result|
        result['addressLines'].to_s
      end
    end
    
    private
    
    def valid_response?
      return unless response['responseData']
      return unless response['responseStatus'] == 200
      return unless response['responseData']['results']
      true
    end
    
    def request
      Net::HTTP.start HOST do |http|
        response = http.request_get(build_url, 'Referer' => @opts[:referer])
        # TODO add some http errors handling here
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

