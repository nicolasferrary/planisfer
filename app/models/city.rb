class City < ApplicationRecord
 has_many :airports, dependent: :destroy
 has_many :trips, dependent: :destroy
 validates :name, presence: true
 validates :country, presence: true
end
