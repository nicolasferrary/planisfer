class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy

  class << self

    def create(sipp)
      car = Car.new()
      car.sipp = sipp
      car.category = extract_category(sipp)
      if !Constants::CAR_IMAGE[sipp.first(2)].nil?
        index = define_index(sipp)
        car.image_url = extract_car_image(sipp, index)
        car.name = extract_car_name(sipp, index)
      end
      # Add car.name taking names from the google doc
      car.save
    end


    def extract_category(sipp)
      sipp_to_category = {
        "M" => "Mini",
        "N" => "Mini",
        "E" => "Economy",
        "H" => "Economy",
        "C" => "Compact",
        "D" => "Compact",
        "I" => "Intermediate",
        "J" => "Intermediate",
        "S" => "Intermediate",
        "R" => "Intermediate",
        "F" => "Fullsize",
        "G" => "Fullsize",
        "P" => "Premium",
        "L" => "Premium",
        "W" => "Premium",
        "O" => "Fullsize",
        "X" => "Special",
      }
      category = sipp_to_category[sipp[0]]
    end

    def define_index(sipp)
      image_array = Constants::CAR_IMAGE[sipp.first(2)]
      index = rand(0..(image_array.count - 1))
    end

    def extract_car_image(sipp, index)
      Constants::CAR_IMAGE[sipp.first(2)][index]
    end

    def extract_car_name(sipp, index)
      Constants::CAR_NAME[sipp.first(2)][index]
    end

  end

end
