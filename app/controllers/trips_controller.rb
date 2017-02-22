class TripsController < ApplicationController

  def show
    options = extract_options_from_stamp(params[:stamp])

    # All offers for one route sorted by price
    @trips = Avion::SmartQPXAgent.new(options).obtain_offers.sort_by { |offer| offer.total }
    @trip = @trips[params[:start].to_i]

    # extract two arrays of roundtrips, one from each city to destination
    # @trips_a = @trips.reduce([]) {|a, e| a << e.roundtrips.first }.uniq { |t| t.trip_id }
    # @trip_a = @trips_a[params[:left].to_i] # set the first roundtrip from city A
  end

  def index

  end


