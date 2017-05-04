class City < ApplicationRecord
 has_many :trips, dependent: :destroy
 validates :name, presence: true


 def self.create(name)
  city = City.new(name: name)
  city.save
  city
 end
end
