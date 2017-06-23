class ExperiencesController < ApplicationController

  def create_experiences

    @regions = []
    member_experiences = current_member.experiences.all
    member_regions =[]
    member_experiences.each do |experience|
      member_regions << experience.region
    end

    new_regions = []
    params[:regions].each do |region_id|
      region = Region.find(region_id.to_i)
      if !member_regions.include?(region)
        new_regions << region
      end
    end

    new_regions.each_with_index do |region, index|
      if index >=1
        Experience.create(member: current_member, region: region)
      end
    end
    first_region = new_regions.first
    @first_experience = Experience.create(member: current_member, region: first_region)
    redirect_to edit_experience_path(@first_experience)

  end

  def edit
    @experiences = current_member.experiences.to_a
    @experience = Experience.find(params[:id])
    @experiences.delete(@experience)
    @experiences.insert(0, @experience)
    @categories = ["Honeymoon", "Road trip", "Family friendly", "Nature/ Sport", "Cutlural", "Relaxing", "Big fiesta", "Local immersion"]
  end

  def update
    @experience = Experience.find(params[:id])
    @experience.length = params[:length]
    @experience.cost = params[:cost]
    @experience.save
    redirect_to new_experience_subexperience_path(experience_id: @experience.id)
  end

end
