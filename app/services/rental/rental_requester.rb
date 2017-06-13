require 'rest-client'

module Rental
  class RentalRequester

    def initialize(args = {})
      @pick_up_place = args[:pick_up_place]
      @drop_off_place = args[:drop_off_place]
      @pick_up_date_time = args[:pick_up_date_time]
      @drop_off_date_time = args[:drop_off_date_time]
      @currency = args[:currency]
      @car_amadeus_api_key = ENV['AMADEUS_SANDBOX_API_KEY']
    end

    def make_request_amadeus
      url = 'https://api.sandbox.amadeus.com/v1.2/cars/search-airport?apikey=' + @car_amadeus_api_key + '&location=' + @pick_up_place + '&pick_up=' + @pick_up_date_time.strftime("%Y-%m-%d") + '&drop_off=' + @drop_off_date_time.strftime("%Y-%m-%d") + '&currency=' + @currency
      response = RestClient.get url
      response.body
    end

  end
end

