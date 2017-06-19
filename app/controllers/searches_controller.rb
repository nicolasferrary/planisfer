class SearchesController < ApplicationController

  def create

    @region = Region.find_by_name(params[:region])
    @search = Search.new(city: params[:city], starts_on: params[:starts_on], returns_on: params[:returns_on], nb_adults: params[:nb_adults] || 0, nb_children: params[:nb_children] || 0, nb_infants: params[:nb_infants] || 0)
    @search.region = @region
    if @search.nb_adults + @search.nb_children + @search.nb_infants == 0
      flash[:search_error] = "Please select at least one passenger"
      return redirect_to root_path
    else
      unless @search.save
        if @search.nb_adults < @search.nb_infants
          flash[:search_error] = "Number of infants can not be higher than number of adults"
        else
          flash[:search_error] = "Please fill empty fields"
        end
        return redirect_to root_path
      end
    end


    @city = params[:city]
    @region_name = @search.region.name
    @starts_on = params[:starts_on]
    @returns_on = params[:returns_on]
    @nb_adults = @search.nb_adults
    @nb_children = @search.nb_children
    @nb_infants = @search.nb_infants
    @all_region_airports = define_all_airports(@region)
    @trips = get_trips_for(@starts_on, @returns_on, @nb_adults, @nb_children, @nb_infants, @city, @search, @all_region_airports)
    @flight_margin = 1.05
    @trips = apply_flight_margin(@trips, @flight_margin)
    redirect_to search_path(@search)

  end

  def show
    @search = Search.find(params[:id])
    @trips = @search.trips
    @region = @search.region
    @all_region_airports = define_all_airports(@region)

    # @region_airports is a array of airports that appear at least once in the possible trips
    @region_airports = define_airports(@trips)
    #@region_airports_cities is an array of airports where airports are concatanated at city level when mult airports in the same city
    @region_airports_cities = define_airports_cities(@region_airports, @all_region_airports)
    #@airport_colours is a hash that gives a colour code to each city in @region_airports
    @airport_colours = define_colours(@region_airports_cities)
    @nb_travelers = @search.nb_adults.to_i + @search.nb_children.to_i + @search.nb_infants.to_i
    @passengers_title = passengers(@nb_travelers)
    @city_name = @search.city
    @city_real_name = Constants::AIRPORTS[@city_name]
    @starts_on = @search.starts_on
    @returns_on = @search.returns_on

    #To hide or show the filters
    @status = "none"

# Is this useful?
    @selected_cities = @region_airports

    params["selected-cities"] == nil if params["selected-cities"] == ""
    if params["selected-cities"] == nil || params["selected-cities"] == ""
      @selected_airports = @region_airports_cities
    else
      @selected_cities = params["selected-cities"].split(",")
      @selected_airports = []
      @region_airports_cities.each do |airport|
        @selected_airports << airport if @selected_cities.include?(airport.cityname)
      end
      @selected_airports
    end

    # Define selected airports based on selected cities

    # Define min and max times based on filters
    @f1_min_time = set_range(params[:flight1_range])[0]
    @f1_max_time = set_range(params[:flight1_range])[1]
    @f2_min_time = set_range(params[:flight2_range])[0]
    @f2_max_time = set_range(params[:flight2_range])[1]

    # Apply index filters and select number of trips to be displayed
    apply_index_filters

    @bags = 0
    # @trips = apply_bag_filters(@trips, @bags)

    @trips = @trips.sort_by { |trip| trip.price }
    @trips_selection = @trips.first(10)
    @round_trips = @trips_selection.map(&:round_trip_flight)
    # Define POIs we want to show on the map
    @pois = define_pois(@region)
    # NB : We should protect code to exclude from @pois any poi that has a nil latitude or longitude

    @initial_markers = build_markers(@pois, @selected_airports)

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
    @initial_markers = build_markers(@pois, [])
    @destination_iata = @trip.round_trip_flight.flight1_destination_airport_iata
    @return_iata = @trip.round_trip_flight.flight2_origin_airport_iata
    @destination_airport = Airport.find_by_iata(@destination_iata)
    @return_airport = Airport.find_by_iata(@return_iata)
    @airport_colours = params[:airport_colours]

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

  def highlight_airport
    @filtered_airport = Airport.find(params[:airport_id]) unless params[:airport_id].nil?

      render json: [{
          lat: @filtered_airport.coordinates.gsub(/\:(.*)/, '').to_f,
          lng: @filtered_airport.coordinates.gsub(/(.*)\:/, '').to_f,
          picture: { url: view_context.image_url("airport-black.svg"), width: 70, height: 35 }
        }].to_json
  end

  def highlight_poi
    @region = Region.find(params[:region_id])
    @pois = define_pois(@region)
    @selected_poi = Poi.find(params[:poi_id])
    @pois_except_selected = @pois.delete_if {|poi| poi == @selected_poi }

    @markers_except_selected = build_markers(@pois_except_selected, [])
    @selected_poi_marker = build_markers(@selected_poi, [])

    render json: (@selected_poi_marker + @markers_except_selected).to_json

  end

  private

  def highlight_coordinates(region, highlight)
    Geocoder.coordinates(Constants::DESTINATIONS[region][highlight])
  end

# @latitude = Geocoder.search("Faro, Portugal")[0].data["geometry"]["location"]["lat"]

  def get_trips_for(starts_on, returns_on, nb_adults, nb_children, nb_infants, city, search, all_region_airports)
    trips = []
    rtfs = []
    all_region_airports.each do |airport|
      options = {
        origin: city,
        destination: airport.iata,
        departure: starts_on,
        return: returns_on,
        nb_adults: nb_adults,
        nb_children: nb_children,
        nb_infants: nb_infants,
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
        origin: city,
        destination: airport.iata,
        departure: starts_on,
        nb_adults: nb_adults,
        nb_children: nb_children,
        nb_infants: nb_infants,
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
        destination: city,
        departure: returns_on,
        nb_adults: nb_adults,
        nb_children: nb_children,
        nb_infants: nb_infants,
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
      trip = Trip.create(starts_on, returns_on, nb_adults, nb_children, nb_infants, city, rtf, search)
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

  def build_markers(pois, airports)
    pois_markers = Gmaps4rails.build_markers(pois) do |poi, marker|
      @poi = poi
      marker.lat poi.latitude
      marker.lng poi.longitude
      marker.title poi.name

      marker.infowindow render_to_string(:partial => "/shared/poi_infowindow", :locals => { :object => poi})
      # marker.json { :id => poi.id }
      marker.picture({
                  :url => view_context.image_url("heart-small.png"),
                  :width   => 39,
                  :height  => 34,
                 })
    end
    airports_markers = Gmaps4rails.build_markers(airports) do |airport, marker|
      marker.lat airport.coordinates.gsub(/\:(.*)/, '').to_f
      marker.lng airport.coordinates.gsub(/(.*)\:/, '').to_f
      marker.infowindow airport.cityname + " airport"
      marker.title ""
      marker.picture({
        :url => view_context.image_url("airport-black.svg"),
        :width   => 70,
        :height  => 35,
      })

    end
    markers = pois_markers + airports_markers
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
      region_airports << Airport.find_by_iata(trip.round_trip_flight.flight1_destination_airport_iata)
      region_airports << Airport.find_by_iata(trip.round_trip_flight.flight2_origin_airport_iata)
    end
    region_airports.to_a
  end

  def define_airports_cities(region_airports, all_region_airports)
    airports_cities = Set.new []
    region_airports.each do |airport|
      if airport.category == "city"
        airports_cities << airport
      else
        cityname = airport.cityname
        airports = Airport.where(cityname: cityname).where(category: "city")
        coord = [airport.coordinates.gsub(/\:(.*)/, '').to_f, airport.coordinates.gsub(/(.*)\:/, '').to_f]
        airport_city = find_city_by_coord(airports, coord)
        airports_cities << airport_city
      end
    end
    airports_cities.to_a
  end

  def define_colours(region_airports)
    colours = {}
    region_airports.each_with_index do |airport, index|
      colours[airport.cityname] = "colour-code-#{index}"
    end
    colours
  end

  def apply_flight_margin(trips, flight_margin)
    trips.each do |trip|
      trip.price = trip.price * flight_margin
      trip.save
    end
    trips
  end

  def find_city_by_coord(airports, coord)
    min_proxy = 1000
    selected_airport = nil
    airports.each do |airport|
      lat = airport.coordinates.gsub(/\:(.*)/, '').to_f
      lng = airport.coordinates.gsub(/(.*)\:/, '').to_f
      proxy = (lat - coord[0]).abs + (lng - coord[1]).abs
      if proxy < min_proxy
        min_proxy = proxy
        selected_airport = airport
      end
    end
    selected_airport
  end

end


