class PagesController < ApplicationController

  def home
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


  private

  def check_status
  end

end

