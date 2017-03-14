class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy
  validates :name, presence: true

  class << self
    def create(data, rental_data)
      car = Car.new
      car.name = rental_data['vehicle']
      car.type = extract_type(data, rental_data)
      car.doors = rental_data['doors']
      car.seats = rental_data['seats']
      car.image_url = rental_data['image_id']['url']
      car.save
      car
    end

    def extract_type(data, rental_data)
      class_id = rental_data['car_class_id']
      type = data['car_classes'].select { |class|
        class['id'] == class_id
      }
      type.first['name']
    end


end
