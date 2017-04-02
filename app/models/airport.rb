class Airport < ApplicationRecord
 belongs_to :city
 belongs_to :region
 validates :name, presence: true
 validates :iata, presence: true

  class << self
   def create(data)
    airport = Airport.new
    airport.name = extract_name(data)
    airport.iata = extract_iata(data)
    airport.save
    airport
   end

   private

    def extract_name(data)
      if data['name'] == nil
        "Unknown"
      else
        data['name']
      end
    end

    def extract_iata(data)
      if data['code'] == nil
        "Unknown"
      else
        data['code']
      end
    end
  end
end
