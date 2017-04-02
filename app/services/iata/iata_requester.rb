require 'rest-client'

module Iata
  class IataRequester
    def initialize(args = {})
      @city = args[:city]
      @api_key = args[:api_key]
    end

    def make_request
      url = 'https://iatacodes.org/api/v6/autocomplete?api_key=' + @api_key + '&query='+ @city.name
      response = RestClient.post(url, content_type: :json, accept: :json)
      response.body
    end
  end
end
