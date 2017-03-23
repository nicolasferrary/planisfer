require 'rest-client'

module Rental
  class RentalRequester

    def initialize(args = {})
      @pick_up_place = args[:pick_up_place]
      @drop_off_place = args[:drop_off_place]
      @pick_up_date_time = args[:pick_up_date_time]
      @drop_off_date_time = args[:drop_off_date_time]
      @driver_age = args[:driver_age]
      @user_ip = args[:user_ip]
      @currency = args[:currency]
      @market = "FR"
      @locale = "en-GB"
      @api_key = args[:api_key]
    end

    def make_request
    #create the session
      url = "http://partners.api.skyscanner.net/apiservices/carhire/liveprices/v2/" + @market + "/" + @currency + "/" + @locale + "/" + @pick_up_place + "/" + @drop_off_place + "/" + @pick_up_date_time.strftime("%FT%R") + "/" + @drop_off_date_time.strftime("%FT%R") + "/" + @driver_age.to_s + "/" + "?apiKey=" + @api_key + "&userip=" + @user_ip
      response = RestClient.get url, {accept: :json, content_type: "application/x-www-form-urlencoded"}

      # poll the results
      sleep 10
      response.headers[:location]
      polling_url = "http://partners.api.skyscanner.net" + response.headers[:location].gsub(/&deltaExclude.*/,"")
      response = RestClient.get polling_url, {accept: :json}
      response.body
    end


  end
end

