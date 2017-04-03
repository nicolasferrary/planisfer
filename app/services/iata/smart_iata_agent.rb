module Iata

  class SmartIataAgent
    def initialize(args = {})
      @city = args[:city]
    end

    def obtain_offers
      json = Iata::IataRequester.new(
        city: @city,
        api_key: ENV['IATACODES_API_KEY']
      ).make_request

      @data = JSON.parse(json)

      if @data['response']['cities'] != []
        airports = create_airports(@data['response']['cities'])
      else
        airports = []
      end
    end

    private

    # This method transforms an array of options from the API result into an array of airports
    def create_airports(options)
      airports = []
      options.each do |option|
        airport = Airport.create(option)
        airports << airport
      end
      airports
    end
  end
end
