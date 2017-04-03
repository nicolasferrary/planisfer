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
    # Authentification see here (https://developer.sabre.com/docs/rest_basics/authentication)
      # Client ID
        # V1:7z0cif7m6wb63vrs:DEVCENTER:EXT
      # Base64 Encoded credentials - intermediary step
        # VjE6N3owY2lmN202d2I2M3ZyczpERVZDRU5URVI6RVhUDQo=
      # Encoded password : ZjhpdEhKTTM=
      # Base64 Encoded credentials - final step
      encoded_credentials = 'VmpFNk4zb3dZMmxtTjIwMmQySTJNM1p5Y3pwRVJWWkRSVTVVUlZJNlJWaFVEUW89OmY4aXRISk0z'

      # Get an access token
        url = 'https://api.test.sabre.com/v2/auth/token'
        response = RestClient.post url, 'grant_type=client_credentials', {authorization: 'Basic ' + encoded_credentials, :content_type => 'application/x-www-form-urlencoded' }
# Invalid request 400 "Invalid payload: grant_type must be specified"
    end

    private


# OLD - Skyscanner api request
    # def make_request
    # #create the session
    #   url = "http://partners.api.skyscanner.net/apiservices/carhire/liveprices/v2/" + @market + "/" + @currency + "/" + @locale + "/" + @pick_up_place + "/" + @drop_off_place + "/" + @pick_up_date_time.strftime("%FT%R") + "/" + @drop_off_date_time.strftime("%FT%R") + "/" + @driver_age.to_s + "/" + "?apiKey=" + @api_key + "&userip=" + @user_ip
    #   response = RestClient.get url, {accept: :json, content_type: "application/x-www-form-urlencoded"}
    #   # poll the results
    #   sleep 10
    #   response.headers[:location]
    #   polling_url = "http://partners.api.skyscanner.net" + response.headers[:location].gsub(/&deltaExclude.*/,"")
    #   response = RestClient.get polling_url, {accept: :json}
    #   response.body
    # end


  end
end

