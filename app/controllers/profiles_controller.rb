class ProfilesController < ApplicationController
  def show
    @member = current_member
    @regions = Region.all
    @selected_regions = define_selected_regions(@member)
    @experiences = current_member.experiences.to_a
    @reviewed_experiences = create_reviewed_exp_array(@experiences)
    @recos = []
    current_member.recos.each do |reco|
      @recos << Region.find_by_name(reco)
    end
    @title_text = build_title_text(@reviewed_experiences)
  end

  def define_selected_regions(member)
    selected_regions = []
    member.experiences.each do |exp|
      selected_regions << exp.region
    end
    selected_regions
  end

  def create_reviewed_exp_array(experiences)
    reviewed_exp = []
    experiences.each do |exp|
      reviewed_exp << exp if exp.subexperiences != []
    end
    reviewed_exp
  end

  def build_title_text(reviewed_experiences)
    if reviewed_experiences == []
      title_text = {
        :text1 => "Build your traveler profile",
        :text2 => "Tell us which countries you loved and we'll tell you where to go next!",
        :text3 => "Let’s get started …",
      }
    else
      title_text = {
        :text1 => "Fill feedbacks for more destinations",
        :text2 => "The more feedbacks you fill, the more recommendations will be accurate",
        :text3 => "Your profile is 75% completed",
      }
    end
  end

end

