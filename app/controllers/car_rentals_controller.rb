require "net/http"

class CarRentalsController < ApplicationController

  def index
    @trip = Trip.find(params[:trip_id])
    @search = @trip.search

    @user_ip = Net::HTTP.get(URI("https://api.ipify.org"))
    # IPv4 address.
    # Otherwise, in dev, you can use Localhost v4 address @user_ip = "127.0.0.1"
    # @user_ip = request.remote_ip
    @currency = 'EUR'
    # Lancer les requetes
    # Commenté pour les test de l'index
    # @car_rentals = get_car_rentals_for_trip(@trip)
    # @car_rentals is an array of instances of car_rentals
    # Commenté pour les test de l'index
    # @car_selection = get_best_car_per_category(@car_rentals)
    # @car_selection is a hash of instances of car_rentals (1 instance per car category)

    # This is just for test
    @car_selection = {
      :mini => CarRental.all[0],
      :economy => CarRental.all[1],
      :compact => CarRental.all[2],
      :standard => nil,
      :fullsize => CarRental.all[3],
      :premium => CarRental.all[4]
    }
     @car_rentals = @car_selection
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

  def get_best_car_per_category(rentals)
    best_cars = {}
    mini_cars = rentals.select {|rental| rental.car.category == "Mini"}
    sorted_mini_cars = mini_cars.sort_by { |rental| rental.price }
    best_mini_car = sorted_mini_cars.first
    best_cars[:mini] = get_best_car(rentals, "Mini")
    best_cars[:economy] = get_best_car(rentals, "Economy")
    best_cars[:compact] = get_best_car(rentals, "Compact")
    best_cars[:standard] = get_best_car(rentals, "Standard")
    best_cars[:fullsize] = get_best_car(rentals, "Fullsize")
    best_cars[:premium] = get_best_car(rentals, "Premium/Luxury")
    best_cars
  end

  def get_best_car(rentals, category)
    cars = rentals.select {|rental| rental.car.category == category}
    sorted_cars = cars.sort_by { |rental| rental.price }
    best_car = sorted_cars.first
  end

end

