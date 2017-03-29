class Trip < ApplicationRecord
 belongs_to :round_trip_flight
 belongs_to :trip
 belongs_to :car_rental
 belongs_to :city
 belongs_to :search
 belongs_to :region
 validates :starts_on, presence: true
 validates :returns_on, presence: true
 validates :nb_travelers, presence: true
 validates :city_id, presence: true
 validates :region_id, presence: true
 validates :round_trip_flight, presence: true



  class << self
    def create(starts_on, returns_on, nb_travelers, city, region, round_trip_flight, search)
      trip = Trip.new(starts_on: starts_on, returns_on: returns_on, nb_travelers: nb_travelers, round_trip_flight: round_trip_flight)
      trip.search = search
      trip.city = city
      trip.region = region
      trip.price = round_trip_flight.price
      trip.car_rental = CarRental.new()
      trip.save
      trip
      raise
    end
  end

end
