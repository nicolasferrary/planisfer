class Car < ApplicationRecord

  class << self

    def create(sipp)
      if !Constants::CAR_IMAGE[sipp.first(2)].nil?
        n = Constants::CAR_IMAGE[sipp.first(2)].count
        (0..(n-1)).each do |i|
          car = Car.new()
          car.sipp = sipp
          car.category = extract_category(sipp)
          car.image_url = extract_car_image(sipp, i)
          car.name = extract_car_name(sipp, i)
          car.save
        end
      else
        car = Car.new()
        car.sipp = sipp
        car.category = extract_category(sipp)
        car.save
      end
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

    def extract_car_image(sipp, i)
      Constants::CAR_IMAGE[sipp.first(2)][i]
    end

    def extract_car_name(sipp, i)
      Constants::CAR_NAME[sipp.first(2)][i]
    end

  end

end
