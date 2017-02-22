module Avion
  # Wraps an individual QPX response
  class QPXResponse
    attr_reader :trips
    def initialize(json) # in JSON
      @data = JSON.parse(json)
      # safeguard for when there are no flights (e.g. Bad Response)
      if !@data['trips']['tripOption'].nil?
        trips = create_trips(@data['trips']['tripOption'])
      else
        trips = [QPXTripOption.new({})]
      end
      @trips = trips
      # TODO: should we nilify data after initialization?
    end

    private

    def create_trips(trips)
      trips.map do |trip|
        QPXTripOption.new(trip)
      end
    end
  end
end
