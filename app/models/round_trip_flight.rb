class RoundTripFlight < ApplicationRecord
  attr_accessor :region

  has_many :trips, dependent: :destroy
  validates :price, presence: true
  validates :flight1_origin_airport_iata, presence: true
  validates :flight1_destination_airport_iata, presence: true
  validates :flight2_origin_airport_iata, presence: true
  validates :flight2_destination_airport_iata, presence: true
  validates :flight1_take_off_at, presence: true
  validates :flight1_landing_at, presence: true
  validates :flight2_take_off_at, presence: true
  validates :flight2_landing_at, presence: true


  # def destination_airport_coordinates
  #   results = Geocoder.coordinates( "#{ flight1_destination_airport_iata } #{ region.name }")
  #   self.latitude_arrive = results[0]
  #   self.longitude_arrive = results[1]
  # end

  # def origin_airport_coordinates
  #   results = Geocoder.coordinates(" #{ flight2_origin_airport_iata } #{ region.name }")
  #   self.latitude_back = results[0]
  #   self.longitude_back = results[1]
  # end

  class << self
    def create_flight(option, region)
      round_trip_flight = RoundTripFlight.new
      round_trip_flight.region = region
      round_trip_flight.currency = extract_currency(option)
      round_trip_flight.price = extract_price(option)
      round_trip_flight.flight1_origin_airport_iata = extract_origin_airport_iata(option, 0)
      round_trip_flight.flight1_destination_airport_iata = extract_destination_airport_iata(option, 0)
      round_trip_flight.flight2_origin_airport_iata = extract_origin_airport_iata(option, 1)
      round_trip_flight.flight2_destination_airport_iata = extract_destination_airport_iata(option, 1)
      round_trip_flight.flight1_take_off_at = extract_take_off_at(option, 0)
      round_trip_flight.flight1_landing_at = extract_landing_at(option, 0)
      round_trip_flight.flight2_take_off_at = extract_take_off_at(option, 1)
      round_trip_flight.flight2_landing_at = extract_landing_at(option, 1)
      round_trip_flight.carrier1 = extract_carrier(option, 0)
      round_trip_flight.carrier2 = extract_carrier(option, 1)
      # round_trip_flight.destination_airport_coordinates
      # round_trip_flight.origin_airport_coordinates
      round_trip_flight.save
      round_trip_flight
    end

    def extract_currency(item)
      item['saleTotal'].match(/\w{3}/).to_s
    end

    def extract_price(item)
      item['saleTotal'].match(/\d+\.*\d+/)[0].to_f
    end

    def extract_origin_airport_iata(item, slice)
      item['slice'][slice]['segment'].first['leg'].first['origin']
    end

    def extract_destination_airport_iata(item, slice)
      item['slice'][slice]['segment'].first['leg'].first['destination']
    end

    def extract_take_off_at(item, slice)
      Time.parse item['slice'][slice]['segment'].first['leg'].first['departureTime']
    end

    def extract_landing_at(item, slice)
      Time.parse item['slice'][slice]['segment'].first['leg'].first['arrivalTime']
    end

    def extract_carrier(item, slice)
      item['slice'][slice]['segment'].first['flight']['carrier']
    end
  end
end
