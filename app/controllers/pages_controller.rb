class PagesController < ApplicationController

  def home
    update_member_status
    @status = current_member.profile_status
    @destination_name = params[:destination] || nil
    @destination = Region.find_by_name(@destination_name) if !@destination_name.nil?
    @main_title = build_main_title(@destination_name)
    @step1_title = build_title(@status)
    @step1_subtitle = build_subtitle(@status)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


  private

  def build_title(status)
    if status == 0
      "Build your traveler profile"
    elsif status == 100
      "Get personalized recommendations"
    else
      "Complete your profile"
    end
  end

  def build_subtitle(status)
    "(#{status}% completed)" unless status == 0 || status == 100
  end

  def build_main_title(destination)
    if destination.nil?
      main_title = "Prepare and book fully customized trips"
    else
      main_title = "Prepare and book a fully customized trip to #{destination}"
    end
  end


end

