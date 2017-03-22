require "net/http"

class CarRentalsController < ApplicationController

  def index
    @trip = Trip.find(params[:trip_id])
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
    # Uncomment if you want to test with a seed
    # @car_rentals = [CarRental.all[0], CarRental.all[1], CarRental.all[2], CarRental.all[3], CarRental.all[4]]
    @car_selection = get_best_cars_per_category(@car_rentals)
    # @car_selection is a hash of instances of car_rentals (1 instance per car category)

    # This is just for test
    @times = ["6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM" ]
    @next_photos = define_next_photo_params(@car_rentals)
  end

  private

  def get_car_rentals_for_trip(trip)
    options = {
        pick_up_place: trip.round_trip_flight.flight1_destination_airport_iata,
        drop_off_place: trip.round_trip_flight.flight2_origin_airport_iata,
        pick_up_date_time: trip.round_trip_flight.flight1_landing_at,
        drop_off_date_time: trip.round_trip_flight.flight2_take_off_at - 60*60,
        driver_age: 30,
        currency: @currency,
        user_ip: @user_ip,
      }
      car_rentals = (Rental::SmartRentalAgent.new(options).obtain_rentals)
      return car_rentals
  end

  def get_best_cars_per_category(rentals)
    category_index = define_category_index
    best_cars = {}
    best_cars[:mini] = get_best_car(rentals, "Mini", category_index[:mini])
    best_cars[:economy] = get_best_car(rentals, "Economy", category_index[:economy])
    best_cars[:compact] = get_best_car(rentals, "Compact", category_index[:compact])
    best_cars[:standard] = get_best_car(rentals, "Intermediate/Standard", category_index[:standard])
    best_cars[:fullsize] = get_best_car(rentals, "Fullsize", category_index[:fullsize])
    best_cars[:premium] = get_best_car(rentals, "Premium/Luxury", category_index[:premium])
    best_cars
  end

  def get_best_car(rentals, category, index)
    cars = rentals.select {|rental| rental.car.category == category}
    sorted_cars = cars.sort_by { |rental| rental.price }
    best_car = sorted_cars[index]
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

  def define_next_photo_params(car_rentals)
    mini_max_param = [4, number_rentals(car_rentals, "Mini")-1].min
    economy_max_param = [4, number_rentals(car_rentals, "Economy")-1].min
    compact_max_param = [4, number_rentals(car_rentals, "Compact")-1].min
    standard_max_param = [4, number_rentals(car_rentals, "Intermediate/Standard")-1].min
    fullsize_max_param = [4, number_rentals(car_rentals, "Fullsize")-1].min
    premium_max_param = [4, number_rentals(car_rentals, "Premium/Luxury")-1].min
    next_photo_params = {}
    if params[:mini_index].to_i == mini_max_param
      next_photo_params[:mini] = 0
    else
      next_photo_params[:mini] = params[:mini_index].to_i + 1
    end
    if params[:economy_index].to_i == economy_max_param
      next_photo_params[:economy] = 0
    else
      next_photo_params[:economy] = params[:economy_index].to_i + 1
    end
    if params[:compact_index].to_i == compact_max_param
      next_photo_params[:compact] = 0
    else
      next_photo_params[:compact] = params[:compact_index].to_i + 1
    end
     if params[:standard_index].to_i == standard_max_param
      next_photo_params[:standard] = 0
    else
      next_photo_params[:standard] = params[:standard_index].to_i + 1
    end
     if params[:fullsize_index].to_i == fullsize_max_param
      next_photo_params[:fullsize] = 0
    else
      next_photo_params[:fullsize] = params[:fullsize_index].to_i + 1
    end
     if params[:premium_index].to_i == premium_max_param
      next_photo_params[:premium] = 0
    else
      next_photo_params[:premium] = params[:premium_index].to_i + 1
    end

    next_photo_params
  end

  def number_rentals(rentals, category)
    category_rentals = rentals.select {|rental| rental.car.category == category}
    category_rentals.count
  end


end

