require 'rest-client'

module Iata
  class IataRequester
    def initialize(args = {})
      @city = args[:city]
      @api_key = args[:api_key]
    end

    def make_request
      url = 'https://iatacodes.org/api/v6/autocomplete?api_key=' + @api_key + '&query='+ @city
      response = RestClient.post(url, content_type: :json, accept: :json)
      response.body
    end

    private

    def compose_request
      # request_hash = {
      #   'request' =>
      #   { 'slice' => [
      #     { 'origin' => @city,
      #       'destination' => @region_airport1,
      #       'date' => @starts_on,
      #       'maxStops' => 0 },
      #     { 'origin' => @region_airport2,
      #       'destination' => @city,
      #       'date' => @returns_on,
      #       'maxStops' => 0 }
      #   ],
      #     'passengers' =>
      #   { 'adultCount' => @nb_travelers,
      #     'infantInLapCount' => 0,
      #     'infantInSeatCount' => 0,
      #     'childCount' => 0,
      #     'seniorCount' => 0 },
      #     'solutions' => @nb_solutions,
      #     'refundable' => false }
      # }
      # JSON.generate(request_hash)
    end
  end
end
