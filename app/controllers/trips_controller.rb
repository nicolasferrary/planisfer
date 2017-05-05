class TripsController < ApplicationController

  def create
  end


  def update
    @selection = Selection.find(params[:selection_id])
    @trip = Trip.find(params[:trip_id])
    @trip.car_rental = define_car_rental(@trip)
    @trip.price = calculate_trip_price(@trip)
    @trip.save

    @pick_up_location = params[:pick_up_location]
    @drop_off_location = params[:drop_off_location]
    @pick_up_date_time = params[:pick_up_date_time]
    @drop_off_date_time = params[:drop_off_date_time]
    @options = {
      :trip_id => @trip.id,
      :pick_up_location => @pick_up_location,
      :drop_off_location => @drop_off_location,
      :pick_up_date_time => @pick_up_date_time,
      :drop_off_date_time => @drop_off_date_time
    }
    redirect_to selection_path(@selection, @options)
  end


  def show
    # @trip = Trip.find(params[:id])
    # @search = @trip.search
    # en attente de pick up a car_rental
    # @selection = @trip.car_rental.selection
  end

  private

  def define_car_rental(trip)
    if params[:car_rental_id].nil?
      @trip.car_rental = nil
    else
      @trip.car_rental = CarRental.find(params[:car_rental_id])
    end
  end

  def calculate_trip_price(trip)
    if trip.car_rental.nil?
      trip.price = trip.round_trip_flight.price
    else
      trip.price = trip.round_trip_flight.price + trip.car_rental.price
    end
  end

end


