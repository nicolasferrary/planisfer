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
      @nb_adults = args[:nb_adults]
      @nb_children = args[:nb_children]
      @nb_infants = args[:nb_infants]
    end

    def obtain_offers
        json = Avion::QPXRequester.new(
          origin: @origin,
          destination: @destination,
          departure: @departure,
          return: @return,
          nb_adults: @nb_adults,
          nb_children: @nb_children,
          nb_infants: @nb_infants,
          nb_solutions: 5,
          api_key: ENV['AMADEUS_SANDBOX_API_KEY']
        ).make_request
      @data = JSON.parse(json) unless json.nil?
    end

    private

    def search_params_make_sense
      (Date.parse(@departure) < Date.parse(@return))
    end

  end
end
