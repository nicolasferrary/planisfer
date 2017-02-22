module Avion
  # Query QPX two requests at a time, only make request if corresponding Offer
  # is not found in Redis cache.
  # TODO: remove debugging puts
  class SmartQPXAgent
    def initialize(args = {})
      @city = args[:city]
      @region = args[:region]
      @starts_on = args[:starts_on]
      @returns_on = args[:returns_on]
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
      # if search_params_make_sense(Constants::AIRPORTS)
        json_a = Avion::QPXRequester.new(
          origin: @city,
          destination: @region,
          starts_on: @starts_on,
          returns_on: @returns_on,
          trip_options: 5,
          api_key: ENV['GOOGLE_QPX_API_KEY']
        ).make_request
        # DEBUG ONLY
        puts "#{@city} - #{@region} request made to QPX"
      # else
      #   raise 'Search params did not make sense'
      # end

      finish = Time.now # debugging
      took_seconds = (finish - start).round(2)

      # Pub-sub part
      # Notify first request is made
      Pusher.trigger('qpx_updates', 'request_made', origin: @city,
                                                    destination: @region,
                                                    took_seconds: took_seconds)

      # start = Time.now # debugging
      # if search_params_make_sense(Constants::AIRPORTS)
      #   json_b = Avion::QPXRequester.new(
      #     origin: @origin_b,
      #     destination: @destination_city,
      #     date_there: @date_there, date_back: @date_back,
      #     trip_options: 5,
      #     api_key: ENV['QPX_KEY']
      #   ).make_request
      #   # DEBUG ONLY
      #   puts "#{@origin_b} - #{@destination_city} request made to QPX"
      # else
      #   raise 'Search params did not make sense'
      # end
      # finish = Time.now # debugging
      # took_seconds = (finish - start).round(2)

      # # Notify second request is made
      # Pusher.trigger('qpx_updates', 'request_made', origin: @origin_b,
      #                                               destination: @destination_city,
      #                                               took_seconds: took_seconds)

      comp_info = {
        starts_on: @starts_on,
        returns_on: @returns_on,
        origin_a: @origin_a,
        destination_city: @destination_city
      }

      # comparator = Avion::QPXComparatorGranular.new(json_a, json_b, comp_info)
      # output = comparator.compare
      # $redis.set(@cache_key_name, Marshal.dump(output))

      # # Notify we are ready to return request data
      # Pusher.trigger('qpx_updates', 'requests_completed', increment: 1,
      #                                                     roundtrips_analyzed: output.length)

      # return an array of matched offers
      output
    end

    # private

    # def search_params_make_sense(constants)
    #   constants.keys.include?(@origin_a) && constants.keys.include?(@origin_b) &&
    #     (Date.parse(@date_there) < Date.parse(@date_back))
    # end

    # TODO: DRY with offers controller and check_against_cache
    # def generate_cache_key_name
    #   alphabetical = [@origin_a, @destination_city].sort
    #   "#{alphabetical.first}_#{alphabetical.last}_#{@destination_city}_#{@date_there}_#{@date_back}"
    # end
  end
end
