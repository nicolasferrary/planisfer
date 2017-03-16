require 'ipaddr'

class CarRentalsController < ApplicationController

  def index
    @trip = Trip.find(params[:trip_id])
    @user_ip = "127.0.0.1" # Localhost IPv4 address. Il faudra récupérer l'adresse IPv4 de l'utilisateur
    # @user_ip = request.remote_ip
    @currency = 'EUR'
    # Lancer les requetes
    @car_rentals = get_car_rentals_for_trip(@trip)
    @car_rentals = @car_rentals.sort_by { |car_rental| car_rental.price }
    @car_selection = @car_rentals.first(4)
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

end

