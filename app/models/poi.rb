class Poi < ApplicationRecord
  validates :name, presence: true
  geocoded_by :location
  after_validation :geocode, if: :location_changed?
  has_many :subexperiences

end
