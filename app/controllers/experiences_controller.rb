class ExperiencesController < ApplicationController

  def create_experiences
    # For each region in params, create an experience
    @regions = []
    member_experiences = current_member.experiences.all
    member_regions =[]
    member_experiences.each do |experience|
      member_regions << experience.region
    end

    params[:regions].each_with_index do |region_id, index|
      if index >=1
        region = Region.find(region_id.to_i)
        Experience.create(member: current_member, region: region) unless member_regions.include?(region)
      end
    end
    first_region = Region.find(params[:regions].first.to_i)
    @first_experience = Experience.create(member: current_member, region: first_region)
    redirect_to edit_experience_path(@first_experience)
  end

  def edit
    @experience = Experience.find(params[:id])
    @categories = ["Honeymoon", "Road trip", "Family friendly", "Nature/ Sport", "Cutlural", "Relaxing", "Big fiesta", "Local immersion"]
  end

end
