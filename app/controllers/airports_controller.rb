class AirportsController < ApplicationController

  def index

    @airports = Airport.all

    respond_to do |format|
      format.html
      format.json { @airports = Airport.search(params[:city]) }
    end
  end
end
