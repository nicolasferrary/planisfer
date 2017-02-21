class RoundTripFlight < ApplicationRecord
 belongs_to :trip
 validates :price, presence: true
 validates :flight1_origin_airport_iata, presence: true
 validates :flight1_destination_airport_iata, presence: true
 validates :flight2_origin_airport_iata, presence: true
 validates :flight2_destination_airport_iata, presence: true
 validates :flight1_take_off_at, presence: true
 validates :flight1_landing_at, presence: true
 validates :flight2_take_off_at, presence: true
 validates :flight2_landing_at, presence: true
end
