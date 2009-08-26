require 'rubygems'
require 'net/http'
require 'addressable/uri'
require 'json'

module AddressBook
  class Google    
    HOST = "ajax.googleapis.com"
    SERVICE_PATH = "/ajax/services/search/local"
    
    NotEnoughResultsError = Class.new StandardError
    InvalidResponseError  = Class.new StandardError
    
    def initialize(opts)
      @opts = opts
      @url = Addressable::URI.new(:scheme => 'http', :host => HOST, :path => SERVICE_PATH)
    end
    
    def fetch
      @addresses = []
      
      query = {:v => '1.0', :start => '0', :rsz => 'large', :q => @opts[:query]}
      
      current_path = build_path(@url, query)

      Net::HTTP.start HOST do |http|
        until(@addresses.length >= @opts[:min]) do 
          response = http.request_get(current_path, 'Referer' => @opts[:referer])
          response = parse_json(response)
          
          raise NotEnoughResultsError unless enough_results?(response)

          @addresses << collect_addresses(response)
    
          current_path = build_path(@url, query.merge(:start => (@addresses.length + 1).to_s))
        end
      end
    
      @addresses.flatten
    end
    
    def enough_results?(response)
      response['responseData']['cursor']['estimatedResultCount'].to_i > @opts[:min]
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
    
    private
    
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

