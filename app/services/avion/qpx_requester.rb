require 'rest-client'

module Avion
  # Has a method #make_request that sends a request to QPX and gets a response
  # in original JSON
  class QPXRequester
    # date should be a string in "YYYY-MM-DD" format
    def initialize(args = {})
      @origin = args[:origin] # airport code
      @destination = args[:destination]
      @starts_on = args[:starts_on]
      @returns_on = args[:returns_on]
      @trip_options = args[:trip_options]
      #  @nb_travelers = args[:nb_travelers]
      @api_key = args[:api_key]
    end

    # TODO: Account for 400
    # RestClient::BadRequest: 400 Bad Request
    def make_request
      url = 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=' + @api_key
      request = compose_request
      response = RestClient.post url, request, content_type: :json, accept: :json
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
          { 'origin' => @origin,
            'destination' => @destination,
            'date' => @starts_on,
            'maxStops' => 0 },
          { 'origin' => @destination,
            'destination' => @origin,
            'date' => @returns_on,
            'maxStops' => 0 }
        ],
          'passengers' =>
        { 'adultCount' => 1,
          'infantInLapCount' => 0,
          'infantInSeatCount' => 0,
          'childCount' => 0,
          'seniorCount' => 0 },
          'solutions' => @trip_options,
          'refundable' => false }
      }
      JSON.generate(request_hash)
    end
  end
end
