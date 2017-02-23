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
    starts_on = params[:starts_on]
    returns_on = params[:returns_on]
    nb_travelers = params[:nb_travelers]
    city = params[:city]
    region = params[:region]
    #for test only. To be changed with constants
    region_iata_codes = ["AGP"]
    city_iata_code = "PAR"

    # generate routes
    routes = Avion.generate_routes(city_iata_code, region_iata_codes)
    #only for debug. To be removed
    @routes = routes

    # # Test all routes against cache
    # uncached_routes = Avion.compare_routes_against_cache(routes, starts_on, returns_on)

    #For each route, send a request with 2 slices
    @trips = get_trips_for_routes(routes, starts_on, returns_on, nb_travelers, city, region)
    @trips_selection = @trips.first(4)



    # Do we have something that is not cached?
    # if uncached_routes.empty?
    #   # This won't do any requests as we work with cache
    #   # @offers = get_offers_for_routes(routes, starts_on, returns_on)
    #   # # clone unfiltered results to check against later
    #   # @unfiltered_offers = @offers.clone
    #   # do filtering
    #   # apply_index_filters
    #   # remove duplicate cities
    #   # @offers = @offers.uniq { |offer| offer.destination_city }
    #   # # and sort by total price
    #   # @offers = @offers.sort_by { |offer| offer.total }
    # else # we have to build a new cache
    #   # save url to redirect back from wait.html.erb via JS
    #   session[:url_for_wait] = request.original_url
    #   # render wait view without any routing
    #   render :wait
    #   # Send requests and build the cache in the background
    #   QueryRoutesJob.perform_later(uncached_routes, starts_on, returns_on, nb_travelers)
    # # end
    # session[:search_url] = request.original_url
  end

  def update
  end

  def create
  end

  def destroy
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
        nb_travelers: nb_travelers
      }
      rtf = (Avion::SmartQPXAgent.new(options).obtain_offers)
      rtf.each do |rtf|
        trip = Trip.create(starts_on, returns_on, nb_travelers, city, region, rtf)
        trips << trip
      end
    end
    return trips
  end

  # def apply_index_filters
  #   # set filters
  #   @filters = params.to_hash.slice("city", "starts_on", "returns_on", "origin_b")

  #   # filter by departure time if asked
  #   if params["departure_time_there"].present? && params["departure_time_there"] != ""
  #     @filters = @filters.merge(departure_time_there: params[:departure_time_there])
  #     @offers = filter_by_departure_time(@offers)
  #   end

  #   #filter by arrival time if asked
  #   if params["arrival_time_back"].present? && params["arrival_time_back"] != ""
  #     @filters = @filters.merge(arrival_time_back: params[:arrival_time_back])
  #     @offers = filter_by_arrival_time(@offers)
  #   end
  # end

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

  # def filter_by_departure_time(offers)
  #   offers.select { |offer|
  #     departure_range.include?(offer.roundtrips.first.departure_time_there) && departure_range.include?(offer.roundtrips.last.departure_time_there)
  #   }
  # end

  # def filter_by_arrival_time(offers)
  #   offers.select { |offer|
  #     arrival_range.include?(offer.roundtrips.first.arrival_time_back) && arrival_range.include?(offer.roundtrips.last.arrival_time_back)
  #   }
  # end
end


