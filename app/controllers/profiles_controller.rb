class ProfilesController < ApplicationController
  def show
    @member = current_member
    @regions = Region.all
    @selected_regions = define_selected_regions(@member)
    @experiences = current_member.experiences.to_a
    @reviewed_experiences = create_reviewed_exp_array(@experiences)
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

end

