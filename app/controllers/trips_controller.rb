class TripsController < ApplicationController

  def create
  end

  def show
    @trip = Trip.find(params[:id])
    @search = @trip.search
  end

end


