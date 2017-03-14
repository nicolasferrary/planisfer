class CarRentalsController < ApplicationController


  def index
    raise
    @trip = Trip.find(params[:trip_id])
    @user_ip = request.remote_ip
    @currency = 'EUR'
    # Lancer les requetes
    @car_rentals = get_car_rentals_for_trip(@trip)
    @car_rentals.sort_by { |car_rental| car_rental.price }
    @car_selection = @car_rentals.first(4)


    # Pour chaque résultat de la requete, rediriger vers une fonction create dans le model _ OK
    # Ne pas oublier de lier à car _ OK
    # ne pas oublier de lier trips à la car rental sélectionnée - OK
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
      car_rentals = (Car_rental::SmartAgent.new(options).obtain_rentals)
      car_rentals.each do |car_rental|
        trip.car_rental = car_rental
      end
      return car_rentals
  end

end


t.float    "price"
    t.string   "currency"
    t.string   "pick_up_location"
    t.string   "drop_off_location"
    t.datetime "pick_up_date_time"
    t.datetime "drop_off_date_time"
    t.integer  "driver_age"
    t.string   "company"
    t.integer  "car_id"
    t.string   "deep_link_url"
