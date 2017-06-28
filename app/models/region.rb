class Region < ApplicationRecord
 validates :name, presence: true
 has_many :round_trip_flights
 has_many :trips, through: :round_trip_flights, dependent: :destroy
 has_many :searches
 has_many :experiences



 def create
  region = Region.new(name: name)
  region.save
  region
 end
end
