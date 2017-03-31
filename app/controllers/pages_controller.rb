class PagesController < ApplicationController
  def home
    respond_to do |format|
      format.html {}
      format.js {}
    end

    # @city = City.create(params[:city])
    @city = "Paris"
    @airports = get_airports(@city)
  end

    #private

    def get_airports(city)
      airports = []
      options =
      {city: city
      }
      results = (Iata::SmartIataAgent.new(options).obtain_offers)
      results.each do |result|
        airport = Airport.create(@city)
        airports << airport
      end
      return airports
    end

end

