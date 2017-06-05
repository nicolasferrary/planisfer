class PagesController < ApplicationController

  def home

    # @logged_in = false

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


  private

  def check_status
  end

end

