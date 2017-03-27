require "net/http"

class SelectionsController < ApplicationController

  def create
    @trip = Trip.find(params[:trip_id])
    #Define params for API
    @pick_up_location = Constants::CITY_REGION.invert[params[:pick_up_location]] || @trip.round_trip_flight.flight1_destination_airport_iata
    @drop_off_location = Constants::CITY_REGION.invert[params[:drop_off_location]] || @trip.round_trip_flight.flight2_origin_airport_iata
    if !params[:pick_up_date_time].nil?
      @pick_up_date_time = Time.zone.parse(params[:pick_up_date_time])
    else
      @pick_up_date_time = @trip.round_trip_flight.flight1_landing_at
    end
    if !params[:drop_off_date_time].nil?
      @drop_off_date_time = Time.zone.parse(params[:drop_off_date_time])
    else
      @drop_off_date_time = @trip.round_trip_flight.flight2_take_off_at - 60*60
    end
    @under_25 = params[:under_25].to_i

    @selection = Selection.new()
    @selection.save
    @search = @trip.search
    @region = @trip.region
    @region_airports_iata = Constants::REGIONS_AIRPORTS[@region.name]
    @region_airports = @region_airports_iata.map { |airport_iata| Constants::CITY_REGION[airport_iata]}
    @user_ip = Net::HTTP.get(URI("https://api.ipify.org"))
    # IPv4 address.
    # Otherwise, in dev, you can use Localhost v4 address @user_ip = "127.0.0.1"
    @currency = 'EUR'

    # Lancer les requetes
    # Comment if you want to test with a seed
    @car_rentals = get_car_rentals_for_trip(@trip)
    # @car_rentals is an array of instances of car_rentals
    @categories = ["Mini", "Economy", "Compact", "Intermediate/Standard", "Fullsize", "Premium/Luxury"]
    @best_car_rentals = []
    @categories.each do |category|
      best_category_cars = get_best_cars(@car_rentals, category)
      @best_car_rentals << best_category_cars
    end

    @best_car_rentals = @best_car_rentals.flatten
    @best_car_rentals.each do |car_rental|
      car_rental.selection = @selection
      car_rental.save
    end

    # Uncomment if you want to test with a seed
    # @car_rentals = [CarRental.all[0], CarRental.all[1], CarRental.all[2], CarRental.all[3], CarRental.all[4]]
    redirect_to selection_path(@selection, :trip_id => @trip.id, :pick_up_location => @pick_up_location, :drop_off_location => @drop_off_location, :under_25 => @under_25, :pick_up_date_time => @pick_up_date_time, :drop_off_date_time => @drop_off_date_time)
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @search = @trip.search
    @selection = Selection.find(params[:id])
    @car_rentals = CarRental.where(selection_id: @selection.id)
    @region = @trip.region
    @region_airports_iata = Constants::REGIONS_AIRPORTS[@region.name]
    @region_airports = @region_airports_iata.map { |airport_iata| Constants::CITY_REGION[airport_iata]}
    @car_selection = get_best_cars_per_category(@car_rentals)
    @pick_up_location = params[:pick_up_location]
    @drop_off_location = params[:drop_off_location]
    @pick_up_date_time = params[:pick_up_date_time]
    @drop_off_date_time = params[:drop_off_date_time]
    @under_25 = params[:under_25]
    set_indexes
    # @car_selection is a hash of arrays of instances of car_rentals (up to 5 instances per car category)

    # This is just for test
    @times = ["6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM" ]
    @photo_params = surounding_params(@car_rentals)

    respond_to do |format|
      format.html {}
      format.js {}
    end

  end

  private

  def get_car_rentals_for_trip(trip)
    options = {
        pick_up_place: @pick_up_location,
        drop_off_place: @drop_off_location,
        pick_up_date_time: @pick_up_date_time,
        drop_off_date_time: @drop_off_date_time,
        driver_age: @under_25 == 1 ? 21 : 30,
        currency: @currency,
        user_ip: @user_ip,
      }
    car_rentals = (Rental::SmartRentalAgent.new(options).obtain_rentals)
  end

  def get_best_cars_per_category(rentals)
    best_cars = {}
    best_cars[:mini] = get_best_cars(rentals, "Mini")
    best_cars[:economy] = get_best_cars(rentals, "Economy")
    best_cars[:compact] = get_best_cars(rentals, "Compact")
    best_cars[:standard] = get_best_cars(rentals, "Intermediate/Standard")
    best_cars[:fullsize] = get_best_cars(rentals, "Fullsize")
    best_cars[:premium] = get_best_cars(rentals, "Premium/Luxury")
    best_cars
  end

  def get_best_cars(rentals, category)
    unique_sorted_cars = get_unique_sorted_cars(rentals, category)
    best_cars = unique_sorted_cars.first(5)
  end

  def define_category_index
    category_index = {
      :mini => params[:mini_index].to_i || 0,
      :economy => 0,
      :compact => 0,
      :standard => 0,
      :fullsize => 0,
      :premium => 0,
    }
  end

  def surounding_params(car_rentals)
    mini_max_param = [4, number_rentals(car_rentals, "Mini")-1].min
    economy_max_param = [4, number_rentals(car_rentals, "Economy")-1].min
    compact_max_param = [4, number_rentals(car_rentals, "Compact")-1].min
    standard_max_param = [4, number_rentals(car_rentals, "Intermediate/Standard")-1].min
    fullsize_max_param = [4, number_rentals(car_rentals, "Fullsize")-1].min
    premium_max_param = [4, number_rentals(car_rentals, "Premium/Luxury")-1].min

    photo_params = {}

    # define next params
    if params[:mini_index].to_i == mini_max_param
      photo_params[:next_mini] = 0
    else
      photo_params[:next_mini] = params[:mini_index].to_i + 1
    end
    if params[:economy_index].to_i == economy_max_param
      photo_params[:next_economy] = 0
    else
      photo_params[:next_economy] = params[:economy_index].to_i + 1
    end
    if params[:compact_index].to_i == compact_max_param
      photo_params[:next_compact] = 0
    else
      photo_params[:next_compact] = params[:compact_index].to_i + 1
    end
     if params[:standard_index].to_i == standard_max_param
      photo_params[:next_standard] = 0
    else
      photo_params[:next_standard] = params[:standard_index].to_i + 1
    end
     if params[:fullsize_index].to_i == fullsize_max_param
      photo_params[:next_fullsize] = 0
    else
      photo_params[:next_fullsize] = params[:fullsize_index].to_i + 1
    end
     if params[:premium_index].to_i == premium_max_param
      photo_params[:next_premium] = 0
    else
      photo_params[:next_premium] = params[:premium_index].to_i + 1
    end

    # define previous params
    if params[:mini_index].to_i == 0 || nil
      photo_params[:previous_mini] = mini_max_param
    else
      photo_params[:previous_mini] = params[:mini_index].to_i - 1
    end
    if params[:economy_index].to_i == 0 || nil
      photo_params[:previous_economy] = economy_max_param
    else
      photo_params[:previous_economy] = params[:economy_index].to_i - 1
    end
    if params[:compact_index].to_i == 0 || nil
      photo_params[:previous_compact] = compact_max_param
    else
      photo_params[:previous_compact] = params[:compact_index].to_i - 1
    end
    if params[:standard_index].to_i == 0 || nil
      photo_params[:previous_standard] = standard_max_param
    else
      photo_params[:previous_standard] = params[:standard_index].to_i - 1
    end
    if params[:fullsize_index].to_i == 0 || nil
      photo_params[:previous_fullsize] = fullsize_max_param
    else
      photo_params[:previous_fullsize] = params[:fullsize_index].to_i - 1
    end
    if params[:premium_index].to_i == 0 || nil
      photo_params[:previous_premium] = premium_max_param
    else
      photo_params[:previous_premium] = params[:premium_index].to_i - 1
    end

    photo_params
  end

  def number_rentals(rentals, category)
    unique_sorted_cars = get_unique_sorted_cars(rentals, category)
    unique_sorted_cars.count
  end

  def set_indexes
    @mini_index = params[:mini_index].to_i || 0
    @economy_index = params[:economy_index].to_i || 0
    @compact_index = params[:compact_index].to_i || 0
    @standard_index = params[:standard_index].to_i || 0
    @fullsize_index = params[:fullsize_index].to_i || 0
    @premium_index = params[:premium_index].to_i || 0
  end

  def get_unique_sorted_cars(rentals, category)
    cars = rentals.select {|rental| rental.car.category == category}
    sorted_cars = cars.sort_by { |rental| rental.price }
    unique_sorted_cars = sorted_cars.uniq {|rental| rental.car}
  end

end

