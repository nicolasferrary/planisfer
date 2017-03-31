module Avion
  # Query QPX two requests at a time, only make request if corresponding Offer
  # is not found in Redis cache.
  # TODO: remove debugging puts
  class SmartQPXAgent
    def initialize(args = {})
      @city = args[:city]
      @region = args[:region]
      @region_airport1 = args[:region_airport1]
      @region_airport2 = args[:region_airport2]
      @starts_on = args[:starts_on]
      @returns_on = args[:returns_on]
      @nb_travelers = args[:nb_travelers]
      # @cache_key_name = generate_cache_key_name
      # while in development
      # puts @cache_key_name
    end

    def obtain_offers
      if search_params_make_sense
        json = Avion::QPXRequester.new(
          city: @city,
          region_airport1: @region_airport1,
          starts_on: @starts_on,
          nb_travelers: @nb_travelers,
          nb_solutions: 20,
          api_key: ENV['AMADEUS_SANDBOX_API_KEY']
        ).make_request

      else
        raise 'Search params did not make sense'
      end

      finish = Time.now # debugging
      took_seconds = (finish - start).round(2)

      # Pub-sub part
      # Notify first request is made
      # Pusher.trigger('qpx_updates', 'request_made', origin: @city,
      #                                               destination: @region,
      #                                               took_seconds: took_seconds)
      @data = JSON.parse(json)

      if !@data['trips']['tripOption'].nil?
        rtf = create_rtf(@data['trips']['tripOption'])
      else
        rtf = []
      end
      @rtf = rtf

      # $redis.set(@cache_key_name, Marshal.dump(output))

      # # Notify we are ready to return request data
      # Pusher.trigger('qpx_updates', 'requests_completed', increment: 1,
      #                                                     roundtrips_analyzed: output.length)


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

    # TODO: DRY with offers controller and check_against_cache
    # def generate_cache_key_name
    #   alphabetical = [@origin_a, @destination_city].sort
    #   "#{alphabetical.first}_#{alphabetical.last}_#{@destination_city}_#{@date_there}_#{@date_back}"
    # end
  end
end
