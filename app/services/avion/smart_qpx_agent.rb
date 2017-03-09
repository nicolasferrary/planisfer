module Avion

  class SmartQPXAgent
    def initialize(args = {})
      @city = args[:city]
      @region = args[:region]
      @region_airport1 = args[:region_airport1]
      @region_airport2 = args[:region_airport2]
      @starts_on = args[:starts_on]
      @returns_on = args[:returns_on]
      @nb_travelers = args[:nb_travelers]
    end

    def obtain_offers

      if search_params_make_sense
        json = Avion::QPXRequester.new(
          city: @city,
          region_airport1: @region_airport1,
          region_airport2: @region_airport2,
          starts_on: @starts_on,
          returns_on: @returns_on,
          nb_travelers: @nb_travelers,
          nb_solutions: 3,
          api_key: ENV['GOOGLE_QPX_API_KEY']
        ).make_request
      else
        raise 'Search params did not make sense'
      end

      @data = JSON.parse(json)

      if !@data['trips']['tripOption'].nil?
        rtf = create_rtf(@data['trips']['tripOption'])
      else
        rtf = []
      end
      @rtf = rtf

    end

    private

    # This method transforms an array of options from the API result into an array of trips
    def create_rtf(options)
      rtfs = []
      options.each do |option|
        rtf = RoundTripFlight.create_flight(option, @region)
        # coordinates = Geocoder.coordinates("IATA, REgion ou ville")
        rtfs << rtf
      end
      rtfs
    end

    def search_params_make_sense
      (Date.parse(@starts_on) < Date.parse(@returns_on))
    end

  end

end
