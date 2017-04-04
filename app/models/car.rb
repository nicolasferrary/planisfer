class Car < ApplicationRecord
  has_many :car_rentals, dependent: :destroy
  validates :name, presence: true




    def extract_category(sipp)
      sipp_to_category{
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
        "X" => "Special"
      }
      category = sipp_to_category[sipp[0]]
    end

  # class << self
  #   def create(data_rental)
  #     car = Car.new
  #     car.name = extract_name(data_rental)
  #     car.category = extract_category(data, data_rental)
  #     car.doors = data_rental['doors']
  #     car.seats = data_rental['seats']
  #     car.image_url = extract_image_url(data, data_rental)
  #     car.save
  #     car
  #   end

  #   def extract_category(data, data_rental)
  #     id = data_rental['car_class_id']
  #     category = data['car_classes'].select { |car_class|
  #       car_class['id'] == id
  #     }
  #     if category == []
  #       "unknown"
  #     else
  #       category.first['name']
  #     end
  #   end

  #   def extract_name(data_rental)
  #     if data_rental['vehicle'] == nil
  #       "Unknown car"
  #     else
  #       data_rental['vehicle'].gsub(" or similar", "")
  #     end
  #   end

  #   def extract_image_url(data, data_rental)
  #     image_id = data_rental['image_id']
  #     image_urls = data['images'].select{ |image|
  #       image['id'] == image_id
  #     }
  #     image_url = image_urls.first['url'] unless image_urls == []
  #   end

  # end

end
