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

  # def self.compare_routes_against_cache(routes, date_there, date_back)
  #   routes.reject do |route|
  #     alphabetical = [route.first, route[1]].sort
  #     $redis.exists("#{alphabetical.first}_#{alphabetical.last}_#{route.last}_#{date_there}_#{date_back}")
  #   end
  # end
end
