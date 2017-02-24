class TripsController < ApplicationController

  # before_action :disable_browser_cache, only: :show
  # before_action :assert_show_params, only: :show
  # before_action :assert_index_params, only: :index


  # def show
  #   options = extract_options_from_stamp(params[:stamp])

  #   # All offers for one route sorted by price
  #   @trips = Avion::SmartQPXAgent.new(options).obtain_offers.sort_by { |offer| offer.total }
  #   @trip = @trips[params[:start].to_i]

  #   # extract two arrays of roundtrips, one from each city to destination
  #   # @trips_a = @trips.reduce([]) {|a, e| a << e.roundtrips.first }.uniq { |t| t.trip_id }
  #   # @trip_a = @trips_a[params[:left].to_i] # set the first roundtrip from city A
  # end

  def index

  end

  def update
  end

  def create
  end

  def show
    @trip = Trip.find(params[:id])
    @search = @trip.search
  end


  private


  # def extract_options_from_stamp(stamp)
  #   from_stamp = params[:stamp].split('_')
  #   {
  #     city: from_stamp.first,
  #     region: from_stamp[1],
  #     starts_on: from_stamp[2],
  #     returns_on: from_stamp.last
  #   }
  # end

  def get_trips_for_routes(routes, starts_on, returns_on, nb_travelers, city, region)
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
        trip = Trip.create(starts_on, returns_on, nb_travelers, city, region, rtf)
        trips << trip
      end
    end
    return trips
  end

  def apply_airport_filters
    # set filters
    @filters = params.to_hash.slice("city", "region", "starts_on", "returns_on", "nb_travelers")

    # filter by airports if asked
    if params["region_airport1"].present? && params["region_airport1"] != ""
      @filters = @filters.merge("region_airport1" => params[:region_airport1])
      @trips = filter_by_airport1(@trips, @filters)
    end

    if params["region_airport2"].present? && params["region_airport2"] != ""
      @filters = @filters.merge("region_airport2" => params[:region_airport2])
      @trips = filter_by_airport2(@trips, @filters)
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

  # def filter_by_airport1(trips, filters)
  #   #trips is an array and filters is a hash
  #   trips.select { |trip|
  #     trip.round_trip_flight.flight1_destination_airport_iata == filters["region_airport1"]
  #   }

  # end

  # def filter_by_airport2(trips, filters)
  #   #trips is an array and filters is a hash
  #   trips.select { |trip|
  #     trip.round_trip_flight.flight2_origin_airport_iata == filters["region_airport2"]
  #   }

  # end



  # def filter_by_arrival_time(offers)
  #   offers.select { |offer|
  #     arrival_range.include?(offer.roundtrips.first.arrival_time_back) && arrival_range.include?(offer.roundtrips.last.arrival_time_back)
  #   }
  # end



  # def select_trips_with_airports(a,b)
  #  trips =[]
  #  @trips.each do |trip|
  #    if trip.round_trip_flight.flight1_destination_airport_iata == @region_airports[a] && trip.round_trip_flight.flight2_origin_airport_iata == @region_airports[b]
  #       trips << trip
  #    end
  #  end
  #  trips
  # end

end


