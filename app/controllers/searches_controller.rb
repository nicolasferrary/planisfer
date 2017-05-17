class SearchesController < ApplicationController

  def create

    @region = Region.find_by_name(params[:region])
    @search = Search.new(city: params[:city], starts_on: params[:starts_on], returns_on: params[:returns_on], nb_travelers: params[:nb_travelers])
    @search.region = @region

    unless @search.save
      flash[:search_error] = "Please fill empty fields"
      return redirect_to root_path
    end

    @city = City.create(params[:city])
    @region_name = @search.region.name
    @starts_on = params[:starts_on]
    @returns_on = params[:returns_on]
    @nb_travelers = params[:nb_travelers]
    @all_region_airports = define_all_airports(@region)

    @trips = get_trips_for(@starts_on, @returns_on, @nb_travelers, @city, @search, @all_region_airports)

    redirect_to search_path(@search)

  end

  def show
    @search = Search.find(params[:id])
    @trips = @search.trips
    @region = @search.region

    # @region_airports is a array of city names for cities that appear at least once in the possible trips
    @region_airports = define_airports(@trips)
    #@airport_colours is a hash that gives a colour code to each city in @region_airports
    @airport_colours = define_colours(@region_airports)
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
#VERIFIER QUE CA SERT ENCORE
    @selected_cities = @region_airports
    # Attribute selected cities in params to @selected cities
    params["selected-cities"] == nil if params["selected-cities"] == ""
    if params["selected-cities"] == nil || params["selected-cities"] == ""
      @selected_cities = @selected_cities
    else
      @selected_cities = params["selected-cities"].split(",")
    end

    # Define selected airports based on selected cities
    @selected_airports = []
    @selected_cities.each do |name|
      airport = Airport.find_by_name(name)
      @selected_airports << airport
    end
    # Define min and max times based on filters
    @f1_min_time = set_range(params[:flight1_range])[0]
    @f1_max_time = set_range(params[:flight1_range])[1]
    @f2_min_time = set_range(params[:flight2_range])[0]
    @f2_max_time = set_range(params[:flight2_range])[1]

    # Apply index filters and select number of trips to be displayed
    apply_index_filters
    @trips = @trips.sort_by { |trip| trip.price }
    @trips_selection = @trips.first(10)
    @round_trips = @trips_selection.map(&:round_trip_flight)

    # Define POIs we want to show on the map
    @pois = define_pois(@region)
    # NB : We should protect code to exclude from @pois any poi that has a nil latitude or longitude

    @initial_markers = build_markers(@pois)

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
    @trip = Trip.find(params[:trip_id])
    @region = @trip.search.region
    @pois = define_pois(@region)
    @initial_markers = build_markers(@pois)
    @destination_iata = @trip.round_trip_flight.flight1_destination_airport_iata
    @return_iata = @trip.round_trip_flight.flight2_origin_airport_iata
    @destination_airport = Airport.find_by_iata(@destination_iata)
    @return_airport = Airport.find_by_iata(@return_iata)
    @airport_colours = params[:airport_colours]

    # # @region_airports is a array of city names for cities that appear at least once in the possible trips
    # @region_airports = define_airports([@trip])
    # #@airport_colours is a hash that gives a colour code to each city in @region_airports
    # @airport_colours = define_colours(@region_airports)

    if @trip.arrival_city == @trip.return_city
      render json: @initial_markers.concat([
        {
          lat: @destination_airport.coordinates.gsub(/\:(.*)/, '').to_f,
          lng: @destination_airport.coordinates.gsub(/(.*)\:/, '').to_f,
          infowindow: @trip.arrival_city,
          json: { :id => 1 },
          picture: { url: view_context.image_url("airport-#{@airport_colours[@trip.arrival_city]}.svg"), width: 70, height: 35 }
        }
        ]).to_json

    else
      render json: @initial_markers.concat([
        {
          lat: @destination_airport.coordinates.gsub(/\:(.*)/, '').to_f,
          lng: @destination_airport.coordinates.gsub(/(.*)\:/, '').to_f,
          infowindow: @trip.arrival_city,
          json: { :id => 1 },
          picture: { url: view_context.image_url("airport-#{@airport_colours[@trip.arrival_city]}.svg"), width: 70, height: 35 }
        },
        {
          lat: @return_airport.coordinates.gsub(/\:(.*)/, '').to_f,
          lng: @return_airport.coordinates.gsub(/(.*)\:/, '').to_f,
          infowindow: @trip.return_city,
          json: { :id => 2 },
          picture: { url: view_context.image_url("airport-#{@airport_colours[@trip.return_city]}.svg"), width: 70, height: 35 }
        }
        ]).to_json
    end
  end

  def highlight_poi
    @region = Region.find(params[:region_id])
    @pois = define_pois(@region)
    @selected_poi = Poi.find(params[:poi_id])
    @pois_except_selected = @pois.delete_if {|poi| poi == @selected_poi }

    @non_highlighted_markers = build_markers(@pois_except_selected)

    render json: @non_highlighted_markers.concat([
      {
        lat: @selected_poi.latitude,
        lng: @selected_poi.longitude,
        infowindow: render_to_string(:partial => "/shared/poi_infowindow", :locals => { :object => @selected_poi}),
        picture: { url: view_context.image_url("orange-camera.svg"), width: 40, height: 44 }
      }
      ]).to_json

  end

  private

  def highlight_coordinates(region, highlight)
    Geocoder.coordinates(Constants::DESTINATIONS[region][highlight])
  end

# @latitude = Geocoder.search("Faro, Portugal")[0].data["geometry"]["location"]["lat"]

  def get_trips_for(starts_on, returns_on, nb_travelers, city, search, all_region_airports)
    trips = []
    rtfs = []
    # create rtf for routes with same landing and departure airports in destination region and add them to rtfs
      # Launch one request
      # Stock results in @data
      # Create rtfs with @data
      # Put each rtf in rtfs
    # same for routes with different airports
      # outbounds =[]
      #inbounds = []
      # For each airport, do
        #launch two requests
        # Stock results in @data1 and @data2
        # Mettre chaque flight de @data 1 dans outbounds
        # Mettre chaque flight de @data2 dans inbounds
      #end
      # Pour chaque flight de @data 1, prendre chaque flight de @data 2 et créer un complex round trip flight
      # Put the rtf in rtfs
    # Create trips for each rtf

    # create rtf for routes with same landing and departure airports in destination region and add them to rtfs

      # Launch one return request per airport, then create rtfs and stck them in rtfs
    all_region_airports.each do |airport|
      options = {
        origin: city.name,
        destination: airport.iata,
        departure: starts_on,
        return: returns_on,
        nb_travelers: nb_travelers,
        region: search.region.name
      }
      @data = (Avion::SmartQPXAgent.new(options).obtain_offers)
      # Create a rtf with @data for each itinerary of each same_airport_route and put it in rtfs
      if !@data.nil?
        if @data['results'] != []
          rtf = create_rtf(@data, @data['results'])
        else
          rtf = []
        end
        rtf.each do |rtf|
          rtfs << rtf
        end
      end
    end
    # end of rtf creation for same_airport routes


    # # create rtf for routes with different landing and departure airports in destination region and add them to rtfs
    outbounds = []
    inbounds = []
    # For each airport launch 2 requests and stock data in outbounds and inbounds arrays
    all_region_airports.each do |airport|
      options1 = {
        origin: city.name,
        destination: airport.iata,
        departure: starts_on,
        nb_travelers: nb_travelers,
        region: search.region.name
      }
      @data1 = (Avion::SmartQPXAgent.new(options1).obtain_offers)
      if !@data1.nil?
        @data1['results'].each do |result|
          result['itineraries'].each do |itinerary|
            outbound_flight = [itinerary, result['fare'], @data1['currency']]
            outbounds << outbound_flight
          end
        end
      end

      options2 = {
        origin: airport.iata,
        destination: city.name,
        departure: returns_on,
        nb_travelers: nb_travelers,
        region: search.region.name
      }
      @data2 = (Avion::SmartQPXAgent.new(options2).obtain_offers)
      if !@data2.nil?
        @data2['results'].each do |result|
          result['itineraries'].each do |itinerary|
            inbound_flight = [itinerary, result['fare'], @data2['currency']]
            inbounds << inbound_flight
          end
        end
      end

    end
# Protéger le code
    if outbounds != [] && inbounds != []
      outbounds.each do |outbound|
        inbounds.each do |inbound|
          if outbound[0]['outbound']['flights'][0]['destination']['airport'] != inbound[0]['outbound']['flights'][0]['origin']['airport']
            rtf = create_complex_rtf(outbound, inbound)
            rtfs << rtf
          end
          #inbound and outoubnd are arrays of 3 elements : the itinerary, the fare and the currency
        end
      end
    end

    # end of rtf creation for different_airport routes

    #create trips with rtf
    rtfs.each do |rtf|
      trip = Trip.create(starts_on, returns_on, nb_travelers, city, rtf, search)
      trips << trip
    end

    return trips

  end

  # This method transforms an array of options from the API result into an array of trips
  def create_rtf(data, results)
    rtfs = []
    results.each do |result|
      result['itineraries'].each do |itinerary|
        rtf = RoundTripFlight.create_flight(data, result, itinerary, @region)
        rtfs << rtf
      end
    end
    rtfs
  end

  def create_complex_rtf(outbound, inbound)
    rtf = RoundTripFlight.create_complex_flight(outbound, inbound, @region)
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
      (trip.round_trip_flight.flight1_take_off_at.hour >= Time.parse(@f1_min_time).hour) &&
      (trip.round_trip_flight.flight1_take_off_at.hour < Time.parse(@f1_max_time).hour)
    }
  end

  def filter_by_f2_takeoff(trips)
    trips.select { |trip|
      trip.round_trip_flight.flight2_take_off_at.hour >= Time.parse(@f2_min_time).hour &&
      trip.round_trip_flight.flight2_take_off_at.hour < Time.parse(@f2_max_time).hour
    }
  end

  def filter_by_selected_airports(trips)
    trips.select { |trip|
      @selected_airports_iata = @selected_airports.map { |airport| airport.iata}
      @selected_airports_iata.include?(trip.round_trip_flight.flight1_destination_airport_iata) &&
      @selected_airports_iata.include?(trip.round_trip_flight.flight2_origin_airport_iata)
    }
  end

  def passengers(nb_travelers)
    if nb_travelers.to_i == 1
      return "1 traveler"
    else
      return "#{nb_travelers} travelers"
    end
  end

  def define_pois(region)
    @pois = []
    @region.pois.each do |poi_name|
      poi = Poi.find_by_name(poi_name.strip)
      @pois << poi
    end
    @pois
  end

  def build_markers(pois)

    markers = Gmaps4rails.build_markers(pois) do |poi, marker|
      @poi = poi
      marker.lat poi.latitude
      marker.lng poi.longitude
      marker.infowindow render_to_string(:partial => "/shared/poi_infowindow", :locals => { :object => poi})
      marker.picture({
                  :url => view_context.image_url("camera.svg"),
                  :width   => 40,
                  :height  => 44,
                 })
    end
  end

  # def build_airport_marker(trip, airport, airport_colours)
  #   markers = Gmaps4rails.build_markers(airport) do |airport, marker|
  #     @airport = airport
  #     marker.lat airport.coordinates.gsub(/\:(.*)/, '').to_f
  #     marker.lng airport.coordinates.gsub(/(.*)\:/, '').to_f
  #     marker.infowindow trip.arrival_city
  #     marker.picture({
  #                 :url => view_context.image_url("airport-#{airport_colours[trip.arrival_city]}.svg"),
  #                 :width   => 70,
  #                 :height  => 35,
  #                })
  #   end
  # end

  def define_all_airports(region)
    all_region_airports =[]
    region.airports.each do |airport_iata|
      airport = Airport.find_by_iata(airport_iata)
      all_region_airports << airport
    end
    all_region_airports
  end

  def define_airports(trips)
    #Sets are a bit like array except they remove duplicates
    region_airports = Set.new []
    trips.each do |trip|
      region_airports << trip.arrival_city
      region_airports << trip.return_city
    end
    region_airports.to_a
  end

  def define_colours(region_airports)
    colours = {}
    region_airports.each_with_index do |airport, index|
      colours[airport] = "colour-code-#{index}"
    end
    colours
  end


end






# OUT ==================================


# def get_trips_for_routes(routes, starts_on, returns_on, nb_travelers, city, region, user_ip, search, currency)
#     trips = []
#     rtfs = []
#     # create rtf for routes with same landing and departure airports in destination region and add them to rtfs
#       # Launch one request
#       # Stock results in @data
#       # Create a rtf with @data
#       # Put the rtf in rtfs
#     # same for routes with different airports
#       # Launch two requests
#       # Stock results in @data1 and @data2
#       # Create a rtf with @data1 and @data2
#       # Put the rtf in rtfs
#     # Create trips for each rtf

#     # create rtf for routes with same landing and departure airports in destination region and add them to rtfs
#     same_airport_routes = routes.select { |route|
#       route[1] == route[2]
#     }
#       # Launch one request per same_airport_route and stock results in @data
#     same_airport_routes.each do |route|
#       options = {
#         origin: route.first,
#         destination: route[1],
#         departure: starts_on,
#         return: returns_on,
#         nb_travelers: nb_travelers,
#         region: region,
#         user_ip: user_ip,
#         currency: currency
#       }
#       @data = (Avion::SmartQPXAgent.new(options).obtain_offers)

#       # Create a rtf with @data for each itinerary of each same_airport_route and put it in rtfs
#       if !@data['itineraries'].nil?
#         rtf = create_rtf(@data, @data['itineraries'])
#       else
#         rtf = []
#       end
#       rtf.each do |rtf|
#         rtfs << rtf
#       end

#     end
#     # end of rtf creation for same_airport routes

#     # create rtf for routes with different landing and departure airports in destination region and add them to rtfs
#     different_airport_routes = routes.select { |route|
#       route[1] != route[2]
#     }

#     # Launch two one way requests per different_airport_route and stock results in @data1 and @data2
#     different_airport_routes.each do |route|
#       #Launch first request
#       options1 = {
#         origin: route.first,
#         destination: route[1],
#         departure: starts_on,
#         return: '',
#         nb_travelers: nb_travelers,
#         region: region,
#         user_ip: user_ip,
#         currency: currency
#       }
#       @data1 = (Avion::SmartQPXAgent.new(options1).obtain_offers)

#       options2 = {
#         origin: route[2],
#         destination: route[3],
#         departure: returns_on,
#         return: '',
#         nb_travelers: nb_travelers,
#         region: region,
#         user_ip: user_ip,
#         currency: currency
#       }
#       @data2 = (Avion::SmartQPXAgent.new(options2).obtain_offers)

#       # Create a rtf with @data1 and @data2 for each itinerary combo of itineraries of @data 1 @data2


#       if !@data1['itineraries'].nil? && !@data2['itineraries'].nil?
#         rtf = create_complex_rtf(@data1, @data1['itineraries'], @data2, @data2['itineraries'])
#       else
#         rtf = []
#       end
#       rtf.each do |rtf|
#         rtfs << rtf
#       end

#     end
#     # end of rtf creation for different_airport routes

#     #create trips with rtf
#     rtfs.each do |rtf|
#       trip = Trip.create(starts_on, returns_on, nb_travelers, city, region, rtf, search)
#       trips << trip
#     end

#     return trips

#   end

#   # This method transforms an array of options from the API result into an array of trips
#   def create_rtf(data, itineraries)
#     rtfs = []
#     itineraries.each do |itinerary|
#       rtf = RoundTripFlight.create_flight(data, itinerary, @region)
#       # coordinates = Geocoder.coordinates("IATA, REgion ou ville")
#       rtfs << rtf
#     end
#     rtfs
#   end

#   # Same with return flights from different airports

#   def create_complex_rtf(data1, itineraries1, data2, itineraries2)
#     rtfs = []
#     itineraries1.each do |itinerary1|
#       itineraries2.each do |itinerary2|
#         rtf = RoundTripFlight.create_complex_flight(data1, itinerary1, data2, itinerary2, @region)
#         # coordinates = Geocoder.coordinates("IATA, REgion ou ville")
#         rtfs << rtf
#       end
#     end
#     rtfs
#   end
