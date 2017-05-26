require 'rest-client'

module Avion
  # Has a method #make_request that sends a request to QPX and gets a response
  # in original JSON
  class QPXRequester
    # date should be a string in "YYYY-MM-DD" format
    def initialize(args = {})
      @origin = args[:origin]
      @destination = args[:destination]
      @departure = args[:departure]
      @return = args[:return]
      @nb_solutions = args[:nb_solutions]
      @nb_adults = args[:nb_adults].nil? ? "0" : args[:nb_adults].to_s
      @nb_children = args[:nb_children].nil? ? "0" : args[:nb_children].to_s
      @nb_infants = args[:nb_infants].nil? ? "0" : args[:nb_infants].to_s
      @api_key = args[:api_key]
      @currency = "EUR"
      @nonstop = true
    end

    # TODO: Account for 400
    # RestClient::BadRequest: 400 Bad Request
    def make_request
      if !@return.nil?
        url = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=' + @api_key + '&origin=' + @origin +'&destination=' + @destination + '&departure_date=' + @departure + '&return_date=' + @return + '&adults=' + @nb_adults + '&children=' + @nb_children + '&infants=' + @nb_infants + '&nonstop=' + @nonstop.to_s + '&currency=' + @currency + '&number_of_results=' + @nb_solutions.to_s
      else
        url = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=' + @api_key + '&origin=' + @origin +'&destination=' + @destination + '&departure_date=' + @departure + '&adults=' + @nb_adults + '&children=' + @nb_children + '&infants=' + @nb_infants + '&nonstop=' + @nonstop.to_s + '&currency=' + @currency + '&number_of_results=' + @nb_solutions.to_s
      end
      response = RestClient.get(url, content_type: :json, accept: :json)
    rescue
      response.body unless response.nil?
    end
  end
end
