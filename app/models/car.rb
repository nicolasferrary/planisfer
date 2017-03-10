class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy
  validates :name, presence: true
end
