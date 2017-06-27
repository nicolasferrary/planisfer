class ProfilesController < ApplicationController
  def show
    @member = current_member
    @regions = Region.all
    @selected_regions = define_selected_regions(@member)
  end

  def define_selected_regions(member)
    selected_regions = []
    member.experiences.each do |exp|
      selected_regions << exp.region
    end
    selected_regions
  end

end
