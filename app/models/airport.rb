class Airport < ApplicationRecord
 belongs_to :city, optional: true
 belongs_to :region, optional: true
 validates :name, presence: true
 validates :iata, presence: true

  class << self

   # def create(data)
   #  airport = Airport.new
   #  airport.name = extract_name(data)
   #  airport.iata = extract_iata(data)
   #  airport.save
   #  airport
   #  building_autocomplete(airport)
   # end

   # private

   #  def extract_name(data)
   #    if data['name'] == nil
   #      "Unknown"
   #    else
   #      data['name']
   #    end
   #  end

   #  def extract_iata(data)
   #    if data['code'] == nil
   #      "Unknown"
   #    else
   #      data['code']
   #    end
   #  end

   #  def building_autocomplete(airport)
   #   @airport_listing = []
   #   @airport_listing << airport
   #   return @airport_listing
   #  end


  end
end
