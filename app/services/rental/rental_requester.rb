require 'rest-client'

module Rental
  class RentalRequester

    def initialize(args = {})
      @pick_up_place = args[:pick_up_place]
      @drop_off_place = args[:drop_off_place]
      @pick_up_date_time = args[:pick_up_date_time]
      @drop_off_date_time = args[:drop_off_date_time]
      @currency = args[:currency]
    end
    def make_request

      access_token = generate_token
      # TODO : To avoid calling new access_token every time, let's stock tokens in a tab and call them unless they are expired (> 600 000 sec) ==> Use https://developer.sabre.com/resources/best_practices#handling-expirations

    # Call the Car Availability Rest API
      car_url = "https://api.test.sabre.com/v2.4.0/shop/cars"
      request_body = compose_body_request
      response = RestClient.post car_url, request_body, {authorization: 'Bearer ' + access_token, :content_type => 'application/json'}
      response.body
    end

    private

    def generate_token
      # Authentification process: see here (https://developer.sabre.com/docs/rest_basics/authentication)

      #Let's test if token is expired
      #Token works for 604 000 sec
      last_access_token = Token.last
      if (!last_access_token.nil?) && (Time.now - last_access_token.created_at < 600000)
        access_token = last_access_token.text
        raise
      else
        token = Token.new()
        # Client ID
          # V1:7z0cif7m6wb63vrs:DEVCENTER:EXT
        # Base64 Encoded credentials - intermediary step
          # VjE6N3owY2lmN202d2I2M3ZyczpERVZDRU5URVI6RVhU
        # Encoded password : ZjhpdEhKTTM=
        # Base64 Encoded credentials - final step
        encoded_credentials = 'VmpFNk4zb3dZMmxtTjIwMmQySTJNM1p5Y3pwRVJWWkRSVTVVUlZJNlJWaFU6WmpocGRFaEtUVE09'

        # Get an access token
        url = 'https://api.test.sabre.com/v2/auth/token'
        response = RestClient.post url, 'grant_type=client_credentials', {authorization: 'Basic ' + encoded_credentials, :content_type => 'application/x-www-form-urlencoded', accept: :json }
        token.text = eval(response.body)[:access_token]
        token.save
        access_token = token
      end
    end

    def compose_body_request

      request_hash = {
        "OTA_VehAvailRateRQ": {
          "VehAvailRQCore": {
            "QueryType": "Shop",
            "RateQualifier": {
              "CurrencyCode": @currency
              },
            "VehRentalCore": {
              "PickUpDateTime": @pick_up_date_time.strftime("%m-%dT%H:%M"),
              "ReturnDateTime": @drop_off_date_time.strftime("%m-%dT%H:%M"),
              "PickUpLocation": {
                "LocationCode": @pick_up_place
              },
              "ReturnLocation": {
                "LocationCode": @drop_off_place
              }
            }
          }
        }
      }
      json = JSON.generate(request_hash)
    end

  end
end

