class Region < ApplicationRecord
 validates :name, presence: true
 has_many :airports, dependent: :destroy
 has_many :trips, dependent: :destroy
 has_many :round_trip_flights, dependent: :destroy



 def self.create(name)
  region = Region.new(name: name)
  region.save
  region
 end

end
