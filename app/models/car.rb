class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy
  validates :name, presence: true

  class << self
    def create(data, rental_data)
      car = Car.new
      car.name = extract_name(rental_data)
      car.category = extract_category(data, rental_data)
      car.doors = rental_data['doors']
      car.seats = rental_data['seats']
      car.image_url = extract_image_url(data, rental_data)
      car.save
      car
    end

    def extract_name(rental_data)
      if data['code'] == nil
        "Unknown car"
      else
        data['code']
      end
    end

  end
end
