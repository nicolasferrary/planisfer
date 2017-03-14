class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy
  validates :name, presence: true

  class << self
    def create(data, rental_data)
      car = Car.new
      car.name = rental_data['vehicle']
      car.type = extract_type(data, rental_data)


      car.save
      car
    end

    def extract_type(data, rental_data)
      class_id = rental_data['car_class_id']
      type =
    end


end
