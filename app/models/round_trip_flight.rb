class RoundTripFlight < ApplicationRecord

  monetize :price_cents

  has_many :trips, dependent: :destroy
  belongs_to :region
  validates :price, presence: true
  validates :flight1_origin_airport_iata, presence: true
  validates :flight1_destination_airport_iata, presence: true
  validates :flight2_origin_airport_iata, presence: true
  validates :flight2_destination_airport_iata, presence: true
  validates :flight1_take_off_at, presence: true
  validates :flight1_landing_at, presence: true
  validates :flight2_take_off_at, presence: true
  validates :flight2_landing_at, presence: true
  validates :f1_number, presence: true
  validates :f2_number, presence: true


  class << self

    def create_flight(data, result, itinerary, region)
      round_trip_flight = RoundTripFlight.new
      round_trip_flight.region = region
      round_trip_flight.currency = extract_currency(data)
      round_trip_flight.price = extract_price(result['fare'])
      round_trip_flight.flight1_origin_airport_iata = extract_origin_airport_iata(itinerary, 'outbound')
      round_trip_flight.flight1_destination_airport_iata = extract_destination_airport_iata(itinerary, 'outbound')
      round_trip_flight.flight2_origin_airport_iata = extract_origin_airport_iata(itinerary, 'inbound')
      round_trip_flight.flight2_destination_airport_iata = extract_destination_airport_iata(itinerary, 'inbound')
      round_trip_flight.flight1_take_off_at = extract_take_off_at(itinerary, 'outbound')
      round_trip_flight.flight1_landing_at = extract_landing_at(itinerary, 'outbound')
      round_trip_flight.flight2_take_off_at = extract_take_off_at(itinerary, 'inbound')
      round_trip_flight.flight2_landing_at = extract_landing_at(itinerary, 'inbound')
      round_trip_flight.carrier1 = extract_carrier(itinerary, 'outbound')
      round_trip_flight.carrier2 = extract_carrier(itinerary, 'inbound')
      round_trip_flight.f1_number = round_trip_flight.carrier1 + extract_flight_number(itinerary, 'outbound')
      round_trip_flight.f2_number = round_trip_flight.carrier2 + extract_flight_number(itinerary, 'inbound')
      round_trip_flight.save
      round_trip_flight
    end

    def create_complex_flight(outbound, inbound, region)
      round_trip_flight = RoundTripFlight.new
      round_trip_flight.region = region
      round_trip_flight.currency = outbound[2]
      round_trip_flight.price = extract_price(outbound[1]).to_f + extract_price(inbound[1]).to_f
      round_trip_flight.flight1_origin_airport_iata = extract_origin_airport_iata(outbound[0], 'outbound')
      round_trip_flight.flight1_destination_airport_iata = extract_destination_airport_iata(outbound[0], 'outbound')
      round_trip_flight.flight2_origin_airport_iata = extract_origin_airport_iata(inbound[0], 'outbound') #because request is done for a one way, so the api will call it an outbound flight
      round_trip_flight.flight2_destination_airport_iata = extract_destination_airport_iata(inbound[0], 'outbound')
      round_trip_flight.flight1_take_off_at = extract_take_off_at(outbound[0], 'outbound')
      round_trip_flight.flight1_landing_at = extract_landing_at(outbound[0], 'outbound')
      round_trip_flight.flight2_take_off_at = extract_take_off_at(inbound[0], 'outbound')
      round_trip_flight.flight2_landing_at = extract_landing_at(inbound[0], 'outbound')
      round_trip_flight.carrier1 = extract_carrier(outbound[0], 'outbound')
      round_trip_flight.carrier2 = extract_carrier(inbound[0], 'outbound')
      round_trip_flight.f1_number = round_trip_flight.carrier1 + extract_flight_number(outbound[0], 'outbound')
      round_trip_flight.f2_number = round_trip_flight.carrier2 + extract_flight_number(inbound[0], 'outbound')
      # round_trip_flight.destination_airport_coordinates
      # round_trip_flight.origin_airport_coordinates
      # round_trip_flight.home_airport_coordinates
      round_trip_flight.save
      round_trip_flight
    end


    def extract_currency(data)
      data['currency']
    end

    def extract_price(fare)
      fare['total_price']
    end

    def extract_origin_airport_iata(itinerary, leg)
      itinerary[leg]['flights'][0]['origin']['airport']
    end

    def extract_destination_airport_iata(itinerary, leg)
      itinerary[leg]['flights'][0]['destination']['airport']
    end

    def extract_take_off_at(itinerary, leg)
      local_time = itinerary[leg]['flights'][0]['departs_at'] + " UTC"
      Time.parse local_time
    end

    def extract_landing_at(itinerary, leg)
      local_time = itinerary[leg]['flights'][0]['arrives_at'] + " UTC"
      Time.parse local_time
    end

    def extract_carrier(itinerary, leg)
      itinerary[leg]['flights'][0]['operating_airline']
    end

    def extract_flight_number(itinerary, leg)
      itinerary[leg]['flights'][0]['flight_number']
    end

  end

end








# OUT =======================








# OUT == From QPX code

    #  def create_flight(option, region)
    #   round_trip_flight = RoundTripFlight.new
    #   round_trip_flight.currency = extract_currency(option)
    #   round_trip_flight.price = extract_price(option)
    #   round_trip_flight.flight1_origin_airport_iata = extract_origin_airport_iata(option, 0)
    #   round_trip_flight.flight1_destination_airport_iata = extract_destination_airport_iata(option, 0)
    #   round_trip_flight.flight2_origin_airport_iata = extract_origin_airport_iata(option, 1)
    #   round_trip_flight.flight2_destination_airport_iata = extract_destination_airport_iata(option, 1)
    #   round_trip_flight.flight1_take_off_at = extract_take_off_at(option, 0)
    #   round_trip_flight.flight1_landing_at = extract_landing_at(option, 0)
    #   round_trip_flight.flight2_take_off_at = extract_take_off_at(option, 1)
    #   round_trip_flight.flight2_landing_at = extract_landing_at(option, 1)
    #   round_trip_flight.carrier1 = extract_carrier(option, 0)
    #   round_trip_flight.carrier2 = extract_carrier(option, 1)
    #   round_trip_flight.f1_number = round_trip_flight.carrier1 + extract_flight_number(option, 0)
    #   round_trip_flight.f2_number = round_trip_flight.carrier2 + extract_flight_number(option, 1)
    #   round_trip_flight.destination_airport_coordinates
    #   round_trip_flight.origin_airport_coordinates
    #   round_trip_flight.home_airport_coordinates
    #   round_trip_flight.region = region
    #   round_trip_flight.save
    #   round_trip_flight
    # end


#     def extract_currency(item)
#       item['saleTotal'].match(/\w{3}/).to_s
#     end

#     def extract_price(item)
#       item['saleTotal'].match(/\d+\.*\d+/)[0].to_f
#     end

#     def extract_origin_airport_iata(item, slice)
#       item['slice'][slice]['segment'].first['leg'].first['origin']
#     end

#     def extract_destination_airport_iata(item, slice)
#       item['slice'][slice]['segment'].first['leg'].first['destination']
#     end

#     def extract_take_off_at(item, slice)
#       string_time = item['slice'][slice]['segment'].first['leg'].first['departureTime']
#       local_string_time = string_time.gsub(/\+(.*)/, '+00:00')
#       Time.zone.parse(local_string_time)
#     end

#     def extract_landing_at(item, slice)
#       string_time = item['slice'][slice]['segment'].first['leg'].first['arrivalTime']
#       local_string_time = string_time.gsub(/\+(.*)/, '+00:00')
#       Time.zone.parse(local_string_time)
#     end

#     def extract_carrier(item, slice)
#       item['slice'][slice]['segment'].first['flight']['carrier']
#     end

#     def extract_flight_number(item, slice)
#       item['slice'][slice]['segment'].first['flight']['number']
#     end

#   end
# end


