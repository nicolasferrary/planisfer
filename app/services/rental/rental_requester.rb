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

      response_url = "http://partners.api.skyscanner.net/apiservices/carhire/liveprices/v2/eyJvIjpbImRhdGFhcGkiLCJHQiIsImVuLUdCIiwiR0JQIiwiRURJIiwiMjAxNy0wNy0wMVQxMDowMDowMCIsIjIwMTctMDctMDdUMTc6MDA6MDAiLCJFREkiLDM1LCIxMjcuMC4wLjEiXSwibiI6LTI1OTAzfQ2"
      # (C'est un exemple ici. Il faudra voir comment la récupérer depuis la post request. D'après la doc, elle est dans le "location header")

    # poll the results
    # La doc n'est pas très claire mais semble dire que la création de session entraine directement le premier poll. tbc
      polling _url = respone_url + '?apiKey=' + @api_key
      response = RestClient.get polling_url, {accept: :json}
      response.body
    end

  end
end

