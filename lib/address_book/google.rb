require 'rubygems'
require 'net/http'
require 'addressable/uri'
require 'json'

module AddressBook
  class Google    
    HOST = "ajax.googleapis.com"
    SERVICE_PATH = "/ajax/services/search/local"
    MAX_RESULTS_PER_QUERY = 32 # google limits us to 32 for local search 
    
    NotEnoughResultsError = Class.new StandardError
    InvalidResponseError  = Class.new StandardError
    
    def initialize(opts)
      @opts = opts
      @url = Addressable::URI.new(:scheme => 'http', :host => HOST, :path => SERVICE_PATH)
    end
    
    def fetch
      addresses = []
      @opts[:queries].each do |query|
        addresses += fetch_query(query)
        break if @opts[:max] !=0 && addresses.length > @opts[:max] 
      end
      
      addresses[0..(@opts[:max] - 1)]
    end
    
    private
  
    def fetch_query(query)
      addresses = []
      
      query = {:v => '1.0', :start => '0', :rsz => 'large', :q => query}
      
      current_path = build_path(@url, query)

      Net::HTTP.start HOST do |http|
        until(addresses.length >= 32) do 
          response = http.request_get(current_path, 'Referer' => @opts[:referer])
          response = parse_json(response)
          
          raise InvalidResponseError unless valid_response?(response)

          addresses += collect_addresses(response)
    
          current_path = build_path(@url, query.merge(:start => (addresses.length).to_s))
        end
      end
    
      addresses
    end
    
    def enough_queries_for_expected_addresses?
      @opts[:query]
    end
    
    def build_url(url,parameters=nil)
      url.query_values = parameters if parameters
      url
    end
    
    def build_path(url, parameters=nil)
      url = build_url(url, parameters) if parameters
      url.path + '?' + url.query # there should be a cleaner way to do this
    end
    
    def collect_addresses(response)
      raise InvalidResponseError unless valid_response? response
      response['responseData']['results'].collect do |result|
        result['addressLines'].join(' ')
      end
    end
        
    def valid_response?(response)
      return unless response['responseData']
      return unless response['responseStatus'] == 200
      return unless response['responseData']['results']
      true
    end
    
    def parse_json(response)
      JSON.parse(response.body)
    end
    
  end
end

