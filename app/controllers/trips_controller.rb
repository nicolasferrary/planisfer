class TripsController < ApplicationController

  def create
  end

  def show
    @trip = Trip.find(params[:id])
    @search = @trip.search

    # en attente de pick up a car_rental
    # @selection = @trip.car_rental.selection
  end

end


