class SearchesController < ApplicationController

  def create
    @search = Search.new(city: params[:city], region: params[:region], starts_on: params[:starts_on], returns_on: params[:returns_on], nb_travelers: params[:nb_travelers])

    unless @search.save
      flash[:search_error] = "Please fill empty fields"
      return redirect_to root_path
    end

    @city = City.create(params[:city])
    @city_name = params[:city]
    @region = Region.create(params[:region])
    @region_name = params[:region]
    @starts_on = params[:starts_on]
    @returns_on = params[:returns_on]
    @nb_travelers = params[:nb_travelers]
    @region_airports = Constants::REGIONS_AIRPORTS[@region_name]

    # TO DELETE
    # @airports = get_airports(@city)

    # generate routes
    @routes = Avion.generate_routes(@city_name, @region_airports)
    # Launch APi requests and gather trips
    @trips = get_trips_for_routes(@routes, @starts_on, @returns_on, @nb_travelers, @city, @region, @search)

    redirect_to search_path(@search)

  end

  def show
    @search = Search.find(params[:id])
    @trips = @search.trips
    @region = @search.region
    @region_airports = Constants::REGIONS_AIRPORTS[@region]
    @selected_airports = @region_airports
    @nb_travelers = @search.nb_travelers
    @passengers_title = passengers(@nb_travelers)
    @city_name = @search.city
    @city_real_name = Constants::AIRPORTS[@city_name]
    @starts_on = @search.starts_on
    @returns_on = @search.returns_on

    #To hide or show the filters
    @status = "none"

    # Initialize selected cities for filters
    @selected_cities = []
    @region_airports.each do |airport|
      @selected_cities << Constants::CITY_REGION[airport]
    end

    # Attribute selected cities in params to @selected cities
    params["selected-cities"] == nil if params["selected-cities"] == ""
    if params["selected-cities"] == nil || params["selected-cities"] == ""
      @selected_cities = @selected_cities
    else
      @selected_cities = params["selected-cities"].split(",")
    end

    # Define selected airports based on selected cities
    @selected_airports = []
    @selected_cities.each do |city|
      airport = Constants::CITY_REGION.invert[city]
      @selected_airports << airport
    end

    # Define min and max times based on filters
    @f1_min_time = set_range(params[:flight1_range])[0]
    @f1_max_time = set_range(params[:flight1_range])[1]
    @f2_min_time = set_range(params[:flight2_range])[0]
    @f2_max_time = set_range(params[:flight2_range])[1]

    apply_index_filters

    @trips = @trips.sort_by { |trip| trip.price }

    @trips_selection = @trips.first(10)

    @round_trips = @trips_selection.map(&:round_trip_flight)

    # Geocode on these objects
    #@round_trips.map(&:destination_airport_coordinates).map(&:origin_airport_coordinates)

    # GEOCODING
    # Define the marker when we load the page
    # Show only one marker if the city is the same for arrival and departure

    # if @round_trips.first.latitude_arrive == @round_trips.first.latitude_back
    #    @first_result = [
    #   # {
    #   #   lat: @round_trips.first.latitude_home,
    #   #   lng: @round_trips.first.longitude_home,
    #   #   infowindow: @round_trips.first.flight1_origin_airport_iata,
    #   #   picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
    #   # },
    #   {
    #     lat: @round_trips.first.latitude_arrive,
    #     lng: @round_trips.first.longitude_arrive,
    #     infowindow: @round_trips.first.flight1_destination_airport_iata,
    #     picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
    #   }]

    # else
    #   @first_result = [
    #     # {
    #     #   lat: @round_trips.first.latitude_home,
    #     #   lng: @round_trips.first.longitude_home,
    #     #   infowindow: @round_trips.first.flight1_origin_airport_iata,
    #     #   picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
    #     # },
    #     {
    #       lat: @round_trips.first.latitude_arrive,
    #       lng: @round_trips.first.longitude_arrive,
    #       infowindow: @round_trips.first.flight1_destination_airport_iata,
    #       picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
    #     },
    #     {
    #       lat: @round_trips.first.latitude_back,
    #       lng: @round_trips.first.longitude_back,
    #       infowindow: @round_trips.first.flight2_origin_airport_iata,
    #       picture: { url: view_context.image_url("orange.svg"), width: 40, height: 40 }
    #     }
    #   ]
    # end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def set_range(range)
    if range.blank?
      flight_range = "4,23"
    else
      flight_range = range
    end

    flight_range_low = flight_range.split(",").first
    flight_range_high = flight_range.split(",")[1]

    if flight_range_low.to_f < 12
      min_time = flight_range_low + "am"
    else
      min_time = (flight_range_low.to_i - 12).to_s + "pm"
    end

    if flight_range_high.to_f < 12
      max_time = flight_range_high + "am"
    else
      max_time = (flight_range_high.to_i - 12).to_s + "pm"
    end
    [min_time, max_time]
  end


  def refresh_map
    # récupérer le round_trip
    @round_trip_flight = RoundTripFlight.find(params[:round_trip_flight_id])
    if @round_trip_flight.longitude_arrive == @round_trip_flight.latitude_back && @round_trip_flight.latitude_arrive == @round_trip_flight.latitude_back
      render json: [
        # To show the city of departure on the map
        # {
        #   lat: @round_trip_flight.latitude_home,
        #   lng: @round_trip_flight.longitude_home,
        #   infowindow: @round_trip_flight.flight1_origin_airport_iata,
        #   picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
        # },
        {
          lat: @round_trip_flight.latitude_arrive,
          lng: @round_trip_flight.longitude_arrive,
          infowindow: @round_trip_flight.flight1_destination_airport_iata,
          picture: { url: view_context.image_url("bleu.svg"), width: 40, height: 40 }
        },
        # in progress = récupérer @region pour pouvoir adapter le code par destination
        {
          #lat: highlight_coordinates("Portugal", "highlight_6")[0],
          lat: 41.1579438,
          lng: -8.629105299999999,
          infowindow: "Hello World",
          picture: { url: view_context.image_url("interest.svg"), width: 40, height: 40 },
        }
        ].to_json
    else
      render json: [
        # To show the city of departure on the map
        # {
        #   lat: @round_trip_flight.latitude_home,
        #   lng: @round_trip_flight.longitude_home,
        #   infowindow: @round_trip_flight.flight1_origin_airport_iata,
        #   picture: { url: view_context.image_url("noir.svg"), width: 40, height: 40 }
        # },
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
        }

        ].to_json
    end
  end

  private

  def highlight_coordinates(region, highlight)
    Geocoder.coordinates(Constants::DESTINATIONS[region][highlight])
  end


  # def highlight_coordinates
  #     @latitude = Geocoder.coordinates("Faro, Portugal")[0],
  #     @longitude = Geocoder.coordinates("Faro, Portugal")[1]
  # end

# @latitude = Geocoder.search("Faro, Portugal")[0].data["geometry"]["location"]["lat"]

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
        trip = Trip.create(starts_on, returns_on, nb_travelers, city, rtf, search)
        trips << trip
      end
    end
    return trips
  end

  def apply_index_filters
    # set filters
    @filters = {}

    if params["flight1_range"].present? && params["flight1_range"] != ""
      @filters = @filters.merge("flight1_range" => @flight1_range)
      @trips = filter_by_f1_takeoff(@trips)
      @status = "block"
    end

    if params["flight2_range"].present? && params["flight2_range"] != ""
      @filters = @filters.merge("flight2_range" => @flight2_range)
      @trips = filter_by_f2_takeoff(@trips)
      @status = "block"
    end

    if params["selected-cities"].present? && params["selected-cities"] != ""
      @filters = @filters.merge("selected_airports" => @selected_airports)
      @trips = filter_by_selected_airports(@trips)
      @status = "block"
    end
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

  def passengers(nb_travelers)
    if nb_travelers.to_i == 1
      return "1 TRAVELER"
    else
      return "#{nb_travelers} TRAVELERS"
    end
  end

  # TO DELETE
  # def get_airports(city)
  #   airports = []
  #   options =
  #   {city: city
  #   }
  #   airports = Iata::SmartIataAgent.new(options).obtain_offers
  #   return airports
  # end

end
