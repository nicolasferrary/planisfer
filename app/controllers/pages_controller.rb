class PagesController < ApplicationController

  def home
    update_member_status
    @status = current_member.profile_status
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

end

