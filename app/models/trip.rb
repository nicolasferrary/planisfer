class Trip < ApplicationRecord
 belongs_to :round_trip_flight
 belongs_to :city
 belongs_to :region
 validates :starts_on, presence: true
 validates :returns_on, presence: true
 validates :nb_travelers, presence: true
 validates :city_id, presence: true
 validates :region_id, presence: true
 validates :round_trip_flight, presence: true

  class << self
    def create(starts_on, returns_on, nb_travelers, city_id, region_id, round_trip_flight)
      trip = Trip.new(starts_on: starts_on, returns_on: returns_on, nb_travelers: nb_travelers, city_id: city_id, region_id: region_id, round_trip_flight: round_trip_flight)
      trip.save
    end
  end

end
