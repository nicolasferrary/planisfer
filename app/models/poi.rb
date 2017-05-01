class Poi < ApplicationRecord
  validates :name, presence: true
  geocoded_by :name
  after_validation :geocode, if: :name_changed?
end
