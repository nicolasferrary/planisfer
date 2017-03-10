class CarRental < ApplicationRecord
  belongs_to :car
  has_many :trips
end
