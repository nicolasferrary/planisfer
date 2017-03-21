require 'rest-client'

module Avion
  # Has a method #make_request that sends a request to QPX and gets a response
  # in original JSON
  class QPXRequester
    # date should be a string in "YYYY-MM-DD" format
    def initialize(args = {})
      @city = args[:city] # airport code
      @region_airport1 = args[:region_airport1]
      @region_airport2 = args[:region_airport2]
      @starts_on = args[:starts_on]
      @returns_on = args[:returns_on]
      @nb_solutions = args[:nb_solutions]
      @nb_travelers = args[:nb_travelers]
      #  @nb_travelers = args[:nb_travelers]
      @api_key = args[:api_key]
    end

    # TODO: Account for 400
    # RestClient::BadRequest: 400 Bad Request
    def make_request
      url = 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=' + @api_key
      request = compose_request
      response = RestClient.post(url, request, content_type: :json, accept: :json)
      response.body
    end

    private

    def compose_request
      # HERE IS A QPX ACCEPTED REQUEST FORM
      # ONLY CHANGE IT TO MAKE MORE VALUES DYNAMIC
      # WITHOUT BREAKING THE STRUCTURE!
      request_hash = {
        'request' =>
        { 'slice' => [
          { 'origin' => @city,
            'destination' => @region_airport1,
            'date' => @starts_on,
            'maxStops' => 0 },
          { 'origin' => @region_airport2,
            'destination' => @city,
            'date' => @returns_on,
            'maxStops' => 0 }
        ],
          'passengers' =>
        { 'adultCount' => @nb_travelers,
          'infantInLapCount' => 0,
          'infantInSeatCount' => 0,
          'childCount' => 0,
          'seniorCount' => 0 },
          'solutions' => @nb_solutions,
          'refundable' => false }
      }
      JSON.generate(request_hash)
    end
  end
end
