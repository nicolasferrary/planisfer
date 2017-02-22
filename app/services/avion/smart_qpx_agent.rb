module Avion
  # Query QPX two requests at a time, only make request if corresponding Offer
  # is not found in Redis cache.
  # TODO: remove debugging puts
  class SmartQPXAgent
    def initialize(args = {})
      @city = args[:city]
      @region_airport1 = args[:region_airport1]
      @region_airport2 = args[:region_airport2]
      @starts_on = args[:starts_on]
      @returns_on = args[:returns_on]
      @nb_travelers = args[:nb_travelers]
      @trip = args[:trip]
      # @cache_key_name = generate_cache_key_name
      # while in development
      # puts @cache_key_name
    end

    def obtain_offers
      # Get deserialized Offer object from cache if found
      # cached = $redis.get(@cache_key_name)
      # if cached
      #   puts "Found key #{@cache_key_name} in cache"
      #   return Marshal.load(cached)
      # end

      # If not – run two requests one after another and try to combine them
      start = Time.now # debugging
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
        # DEBUG ONLY
        puts "#{@city} - #{@region} request made to QPX"
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
      rtf = create_trips(@data['trips']['tripOption'])
      # $redis.set(@cache_key_name, Marshal.dump(output))

      # # Notify we are ready to return request data
      # Pusher.trigger('qpx_updates', 'requests_completed', increment: 1,
      #                                                     roundtrips_analyzed: output.length)


    end

    private

    # This method transforms an array of options from the API result into an array of instances of RoundTripFlight
    def create_trips(options)
      options.map do |option|
        RoundTripFlight.create_flight(option, @trip)
        #ca renvoie True au lieu de renvoyer une instance de RoundTripFlight
      end
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
