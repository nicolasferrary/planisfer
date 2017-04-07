class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy

  class << self

    def create(sipp)
      car = Car.new()
      car.sipp = sipp
      car.category = extract_category(sipp)
      if !Constants::CAR_IMAGE[sipp.first(2)].nil?
        car.image_url = Constants::CAR_IMAGE[sipp.first(2)]
        car.name = Constants::CAR_NAME[sipp.first(2)]
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
  end

end
