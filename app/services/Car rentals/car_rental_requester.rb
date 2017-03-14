require 'rest-client'

module Car_rental
  class CarRentalRequester
    def initialize(args = {})
      @pick_up_place = args[:pick_up_place],
      @drop_off_place = args[:drop_off_place],
      @pick_up_date_time = args[:pick_up_date_time],
      @drop_off_date_time = args[:drop_off_date_time],
      @driver_age = args[:driver_age],
      @user_ip = args[:user_ip],
      @currency = args[:currency]
      @market = "FR"
      @locale = "en-GB"
      @api_key = args[:api_key]
    end

    def make_request
      GET http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/@market/@currency/@locale/@city/@region_airport1/@starts_on/@returns_on?apiKey=@api_key HTTP/1.1
    end

    private

    # def compose_request
    #   # HERE IS A QPX ACCEPTED REQUEST FORM
    #   # ONLY CHANGE IT TO MAKE MORE VALUES DYNAMIC
    #   # WITHOUT BREAKING THE STRUCTURE!
    #   request_hash = {
    #     'request' =>
    #     { 'slice' => [
    #       { 'origin' => @city,
    #         'destination' => @region_airport1,
    #         'date' => @starts_on,
    #         'maxStops' => 0 },
    #       { 'origin' => @region_airport2,
    #         'destination' => @city,
    #         'date' => @returns_on,
    #         'maxStops' => 0 }
    #     ],
    #       'passengers' =>
    #     { 'adultCount' => @nb_travelers,
    #       'infantInLapCount' => 0,
    #       'infantInSeatCount' => 0,
    #       'childCount' => 0,
    #       'seniorCount' => 0 },
    #       'solutions' => @nb_solutions,
    #       'refundable' => false }
    #   }
    #   JSON.generate(request_hash)
    # end
  end
end
