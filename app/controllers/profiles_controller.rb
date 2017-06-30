class ProfilesController < ApplicationController
  def show
    update_member_status
    @member = current_member
    @regions = Region.all
    @experiences = current_member.experiences.to_a
    @reviewed_experiences = create_reviewed_exp_array(@experiences)
    @reviewed_regions = find_regions(@reviewed_experiences)
    @all_created_experiences_regions = find_regions(@experiences)
    @created_regions = @all_created_experiences_regions - @reviewed_regions
    @recos = []
    current_member.recos.each do |reco|
      @recos << Region.find_by_name(reco)
    end
    @title_text = build_title_text(@reviewed_experiences)
    @confirmable = true if @experiences != []
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
      }
    end
  end

  def find_regions(experiences)
    regions = []
    experiences.each do |exp|
      regions << exp.region
    end
    regions
  end

end

