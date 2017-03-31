module Avion
  # Query QPX two requests at a time, only make request if corresponding Offer
  # is not found in Redis cache.
  # TODO: remove debugging puts
  class SmartQPXAgent
    def initialize(args = {})
      @origin = args[:origin]
      @region = args[:region]
      @destination = args[:destination]
      @departure = args[:departure]
      @return = args[:return]
      @nb_travelers = args[:nb_travelers]
    end

    def obtain_offers
      if search_params_make_sense
        json = Avion::QPXRequester.new(
          origin: @origin,
          destination: @destination,
          departure: @departure,
          return: @return,
          nb_travelers: @nb_travelers,
          nb_solutions: 20,
          api_key: ENV['AMADEUS_SANDBOX_API_KEY']
        ).make_request

      else
        raise 'Search params did not make sense'
      end

      @data = JSON.parse(json)
    end
  end
end
