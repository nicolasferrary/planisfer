module Avion
  # MODULE METHODS

  def self.generate_routes(city_iata, region_iatas)
    routes = []
    region_iatas.each do |iata|
      region_iatas.each do |i|
        routes << [city_iata, iata, i, city_iata]
      end
    end
    routes

  end


end
