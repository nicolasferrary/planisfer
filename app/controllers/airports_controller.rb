class AirportsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { @airports = Airport.search(params[:term]) }
    end
  end
end
