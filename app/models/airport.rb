class Airport < ApplicationRecord
   validates :name, presence: true
   validates :iata, presence: true


  # def display_names(airports)
  #   airports.each do |airport|
  #     "#{airport.name} - #{airport.iata}"
  #   end
  # end

end

