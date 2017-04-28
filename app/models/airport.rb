class Airport < ApplicationRecord
   belongs_to :city, optional: true
   belongs_to :region, optional: true
   validates :name, presence: true
   validates :iata, presence: true

  attr_reader :name, :iata
  def initialize(name, iata)
    @name = name
    @iata = iata
  end


  # def display_names(airports)
  #   airports.each do |airport|
  #     "#{airport.name} - #{airport.iata}"
  #   end
  # end

end

