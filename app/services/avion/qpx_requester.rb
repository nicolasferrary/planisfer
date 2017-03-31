require 'rest-client'

module Avion
  # Has a method #make_request that sends a request to QPX and gets a response
  # in original JSON
  class QPXRequester
    # date should be a string in "YYYY-MM-DD" format
    def initialize(args = {})
      @origin = args[:city] # airport code
      @destination = args[:region_airport1]
      @departure_date = args[:starts_on]
      @nb_solutions = args[:nb_solutions]
      @nb_travelers = args[:nb_travelers]
      @api_key = args[:api_key]
    end

    # TODO: Account for 400
    # RestClient::BadRequest: 400 Bad Request
    def make_request
      url = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=' + @api_key + '&origin=' + @origin +'&destination=' + @destination + '&departure_date=' + @departure_date + '&adults=' + @nb_travelers + '&nonstop=true' + '&currency=EUR' + '&number_of_results=' + @nb_solutions
      response = RestClient.get(url, content_type: :json, accept: :json)
      response.body
    end

  end
end
