class Trip < ApplicationRecord

  monetize :price_cents

  belongs_to :round_trip_flight
  belongs_to :car_rental, optional: true
  belongs_to :city
  belongs_to :search
  validates :starts_on, presence: true
  validates :returns_on, presence: true
  validates :nb_travelers, presence: true
  validates :city_id, presence: true
  validates :round_trip_flight, presence: true




  class << self
    def create(starts_on, returns_on, nb_travelers, city, round_trip_flight, search)
      trip = Trip.new(starts_on: starts_on, returns_on: returns_on, nb_travelers: nb_travelers, round_trip_flight: round_trip_flight)
      trip.search = search
      trip.city = city
      trip.price = round_trip_flight.price
      trip.car_rental = CarRental.new()
      trip.save
      trip
    end
  end

end
