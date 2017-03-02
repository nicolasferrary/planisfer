class SearchesController < ApplicationController

  def create
#@search =Search.new avec tout ce qu'on a récupéré en params
    @search = Search.new(city: params[:city], region: params[:region], starts_on: params[:starts_on], returns_on: params[:returns_on], nb_travelers: params[:nb_travelers])
    @search.save
    @city = City.create(params[:city])
    @region = Region.create(params[:region])
    #Lancer les requetes API et tout le code qui va avec.
    @starts_on = params[:starts_on]
    @returns_on = params[:returns_on]
    @nb_travelers = params[:nb_travelers]
    @city_name = params[:city]
    @region_name = params[:region]


    @region_airports = Constants::REGIONS_AIRPORTS[@region_name]

    @city_real_name = Constants::CITY_REGION[@city_name]

    # generate routes
    routes = Avion.generate_routes(@city_name, @region_airports)

    @routes = routes

    @trips = get_trips_for_routes(routes, @starts_on, @returns_on, @nb_travelers, @city, @region, @search)

    redirect_to search_path(@search)

  end

  def show
    @search = Search.find(params[:id])
    @region = @search.region
    @region_airports = Constants::REGIONS_AIRPORTS[@region]
    @selected_airports = @region_airports
    #array de code iatas
    @selected_cities = []
    @region_airports.each do |airport|
      @selected_cities << Constants::CITY_REGION[airport]
    end

    params["selected-cities"] == nil if params["selected-cities"] == ""

    if params["selected-cities"] == nil || params["selected-cities"] == ""
      @selected_cities = @selected_cities
    else
      @selected_cities = params["selected-cities"].split(",")
    end

    @selected_airports = []

    @selected_cities.each do |city|
      airport = Constants::CITY_REGION.invert[city]
      @selected_airports << airport
    end

    if params[:flight1_range].blank?
      @flight1_range = "0,23"
    else
      @flight1_range = params[:flight1_range]
    end

    @flight1_range_low = @flight1_range.split(",").first
    @flight1_range_high = @flight1_range.split(",")[1]
    @flight1_range = @flight1_range_low + "," + @flight1_range_high

    if @flight1_range_low.to_f < 12
      @f1_min_time = @flight1_range_low + "am"
    else
      @f1_min_time = (@flight1_range_low.to_i - 12).to_s + "pm"
    end

    if @flight1_range_high.to_f < 12
      @f1_max_time = @flight1_range_high + "am"
    else
      @f1_max_time = (@flight1_range_high.to_i - 12).to_s + "pm"
    end

    if params[:flight2_range].blank?
      @flight2_range = "0,23"
    else
      @flight2_range = params[:flight2_range]
    end
    @flight2_range_low = @flight2_range.split(",").first
    @flight2_range_high = @flight2_range.split(",")[1]
    @flight2_range = @flight2_range_low + "," + @flight2_range_high

    if @flight2_range_low.to_f < 12
      @f2_min_time = @flight2_range_low + "am"
    else
      @f2_min_time = (@flight2_range_low.to_i - 12).to_s + "pm"
    end

    if @flight2_range_high.to_f < 12
      @f2_max_time = @flight2_range_high + "am"
    else
      @f2_max_time = (@flight2_range_high.to_i - 12).to_s + "pm"
    end


    @trips = @search.trips
    @region_airport1 = params[:region_airport1] || ""
    @region_airport2 = params[:region_airport2] || ""

    apply_index_filters

    @city_name = @search.city
    @city_real_name = Constants::AIRPORTS[@city_name]
    @starts_on = @search.starts_on
    @returns_on = @search.returns_on

    @trips = @trips.sort_by { |trip| trip.price }

    @trips_selection = @trips.first(4)

    if @trips_selection != []
      @trip_cheapest_price = @trips_selection.first.price.round
    end

    @round_trips = @trips_selection.map(&:round_trip_flight)

    # declenche le geocode sur ces objets
    #@round_trips.map(&:destination_airport_coordinates).map(&:origin_airport_coordinates)


    # Here we define selections of trips that match f1 destination airport and f2 origin airport
    @trips0_0 = select_trips_with_airports(0,0)
    @trips0_1 = select_trips_with_airports(0,1)
    @trips0_2 = select_trips_with_airports(0,2)
    @trips0_3 = select_trips_with_airports(0,3)
    @trips1_0 = select_trips_with_airports(1,0)
    @trips1_1 = select_trips_with_airports(1,1)
    @trips1_2 = select_trips_with_airports(1,2)
    @trips1_3 = select_trips_with_airports(1,3)
    @trips2_0 = select_trips_with_airports(2,0)
    @trips2_1 = select_trips_with_airports(2,1)
    @trips2_2 = select_trips_with_airports(2,2)
    @trips2_3 = select_trips_with_airports(2,3)
    @trips3_0 = select_trips_with_airports(3,0)
    @trips3_1 = select_trips_with_airports(3,1)
    @trips3_2 = select_trips_with_airports(3,2)
    @trips3_3 = select_trips_with_airports(3,3)


    # GEOCODING

    if @round_trips.first.latitude_arrive == @round_trips.first.latitude_back
       @first_result = [
      {
        lat: @round_trips.first.latitude_home,
        lng: @round_trips.first.longitude_home,
        infowindow: @round_trips.first.flight1_origin_airport_iata,
        picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
      },
      {
        lat: @round_trips.first.latitude_arrive,
        lng: @round_trips.first.longitude_arrive,
        infowindow: @round_trips.first.flight1_destination_airport_iata,
        picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
      }]
    else
      @first_result = [
        {
          lat: @round_trips.first.latitude_home,
          lng: @round_trips.first.longitude_home,
          infowindow: @round_trips.first.flight1_origin_airport_iata,
          picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
        },
        {
          lat: @round_trips.first.latitude_arrive,
          lng: @round_trips.first.longitude_arrive,
          infowindow: @round_trips.first.flight1_destination_airport_iata,
          picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
        },
        {
          lat: @round_trips.first.latitude_back,
          lng: @round_trips.first.longitude_back,
          infowindow: @round_trips.first.flight2_origin_airport_iata,
          picture: { url: view_context.image_url("orange.svg"), width: 40, height: 40 }
        }
      ]
    end

  end


  def refresh_map
    # récupérer le round_trip
    @round_trip_flight = RoundTripFlight.find(params[:round_trip_flight_id])
    # renvoyer les coordonnées des marqueurs à afficher
    latitude_arrive = @round_trip_flight.latitude_arrive
    longitude_arrive = @round_trip_flight.longitude_arrive
    latitude_back = @round_trip_flight.latitude_back
    longitude_back = @round_trip_flight.longitude_back

    if longitude_arrive == longitude_back && latitude_arrive == latitude_back
      render json: [
        {
          lat: @round_trip_flight.latitude_home,
          lng: @round_trip_flight.longitude_home,
          infowindow: @round_trip_flight.flight1_origin_airport_iata,
          picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
        },
        {
          lat: @round_trip_flight.latitude_arrive,
          lng: @round_trip_flight.longitude_arrive,
          infowindow: @round_trip_flight.flight1_destination_airport_iata,
          picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
        }].to_json
    else
      render json: [
          {
            lat: @round_trip_flight.latitude_home,
            lng: @round_trip_flight.longitude_home,
            infowindow: @round_trip_flight.flight1_origin_airport_iata,
            picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
          },
          {
            lat: @round_trip_flight.latitude_arrive,
            lng: @round_trip_flight.longitude_arrive,
            infowindow: @round_trip_flight.flight1_destination_airport_iata,
            picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
          },
          {
            lat: @round_trip_flight.latitude_back,
            lng: @round_trip_flight.longitude_back,
            infowindow: @round_trip_flight.flight2_origin_airport_iata,
            picture: { url: view_context.image_url("orange.svg"), width: 40, height: 40 }
          }].to_json
    end
  end

  private

  def get_trips_for_routes(routes, starts_on, returns_on, nb_travelers, city, region, search)
    trips = []
    routes.each do |route|
      options = {
        city: route.first,
        region_airport1: route[1],
        region_airport2: route[2],
        starts_on: starts_on,
        returns_on: returns_on,
        nb_travelers: nb_travelers,
        region: region
      }
      rtf = (Avion::SmartQPXAgent.new(options).obtain_offers)
      rtf.each do |rtf|
        trip = Trip.create(starts_on, returns_on, nb_travelers, city, region, rtf, search)
        trips << trip
      end
    end
    return trips
  end

  def apply_index_filters
    # set filters
    @filters = {}


    # filter by airports if asked
    if params["region_airport1"].present? && params["region_airport1"] != ""
      @filters = @filters.merge("region_airport1" => params[:region_airport1])
      @trips = filter_by_airport1(@trips, @filters)
    end

    if params["region_airport2"].present? && params["region_airport2"] != ""
      @filters = @filters.merge("region_airport2" => params[:region_airport2])
      @trips = filter_by_airport2(@trips, @filters)
    end

    if params["flight1_range"].present? && params["flight1_range"] != ""
      @filters = @filters.merge("flight1_range" => @flight1_range)
      @trips = filter_by_f1_takeoff(@trips)
    end

    if params["flight2_range"].present? && params["flight2_range"] != ""
      @filters = @filters.merge("flight2_range" => @flight2_range)
      @trips = filter_by_f2_takeoff(@trips)
    end

    if params["selected-cities"].present? && params["selected-cities"] != ""
      @filters = @filters.merge("selected_airports" => @selected_airports)

      @trips = filter_by_selected_airports(@trips)
    end

  end

  # def assert_show_params
  #   # safeguard agains random urls starting with offers/
  #   unless params[:stamp] =~ /\w{3}_\w{3}_\w{3}_\d{4}-\d{2}-\d{2}_\d{4}-\d{2}-\d{2}/
  #     redirect_to root_path
  #     return
  #   end
  #   # Don't bother making requests if corresponding stamp not found in cache
  #   if $redis.get(params[:stamp]).nil?
  #     redirect_to root_path
  #     return
  #   end
  # end

  # def assert_index_params
  #   # if there are no query params in URL or they don't make sense - send user to home page
  #   if URI(request.original_url).query.blank? || params_fail?
  #     redirect_to root_path
  #     return
  #   end
  # end

  # def disable_browser_cache
  #   # do not cache the page to avoid caching waiting animation
  #   response.headers['Cache-Control'] = "no-cache, max-age=0, must-revalidate, no-store"
  # end

  # TODO: verify if starts_on is not later than returns_on
  # def params_fail?
  #   params[:city].blank? || params[:origin_b].blank? || params[:starts_on].blank? || params[:returns_on].blank?
  # end

  # def departure_range
  #   departure_as_date = Time.new(Time.parse(params[:starts_on]).to_a[5],Time.parse(params[:starts_on]).to_a[4],Time.parse(params[:starts_on]).to_a[3])
  #   (departure_as_date + departure_time_choice.first.hours .. departure_as_date + departure_time_choice.last.hours)
  # end

  # def arrival_range
  #   arrival_as_date = Time.new(Time.parse(params[:returns_on]).to_a[5],Time.parse(params[:returns_on]).to_a[4],Time.parse(params[:returns_on]).to_a[3])
  #   (arrival_as_date + arrival_time_choice.first.hours .. arrival_as_date + arrival_time_choice.last.hours)
  # end

  def filter_by_airport1(trips, filters)
    trips.select { |trip|
      trip.round_trip_flight.flight1_destination_airport_iata == filters["region_airport1"]
    }
  end

  def filter_by_airport2(trips, filters)
    trips.select { |trip|
      trip.round_trip_flight.flight2_origin_airport_iata == filters["region_airport2"]
    }
  end


  def filter_by_f1_takeoff(trips)
    trips.select { |trip|
      (trip.round_trip_flight.flight1_take_off_at.localtime.hour >= Time.parse(@f1_min_time).hour) &&
      (trip.round_trip_flight.flight1_take_off_at.localtime.hour < Time.parse(@f1_max_time).hour)
    }
  end

  def filter_by_f2_takeoff(trips)
    trips.select { |trip|
      trip.round_trip_flight.flight2_take_off_at.localtime.hour >= Time.parse(@f2_min_time).hour &&
      trip.round_trip_flight.flight2_take_off_at.localtime.hour < Time.parse(@f2_max_time).hour
    }
  end

  def filter_by_selected_airports(trips)
    trips.select { |trip|
      @selected_airports.include?(trip.round_trip_flight.flight1_destination_airport_iata) &&
      @selected_airports.include?(trip.round_trip_flight.flight2_origin_airport_iata)
    }
  end


  def select_trips_with_airports(a,b)
    trips =[]
    @trips.each do |trip|
      if trip.round_trip_flight.flight1_destination_airport_iata == @region_airports[a] && trip.round_trip_flight.flight2_origin_airport_iata == @region_airports[b]
        trips << trip
      end
    end
    trips
  end

end
