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
      Experience.create(member: current_member, region: region)
    end

    redirect_to experiences_path
  end

  def index

    @experiences = current_member.experiences.to_a
    @reviewed_experiences = create_reviewed_exp_array(@experiences)
    @non_reviewed_experiences = @experiences - @reviewed_experiences
    @clicked_exp_id = params[:clicked] || nil
    @experience = define_focused_experience(@non_reviewed_experiences, @clicked_exp_id, @experiences.first)
    put_first_exp_first_in_array(@experience, @experiences)
    @categories = ["Honeymoon", "Road trip", "Family friendly", "Nature/ Sport", "Cultural", "Relaxing", "Big fiesta", "Local immersion"]

  end

  def update
    @experience = Experience.find(params[:id])
    @experience.length = params[:length]
    @experience.cost = params[:cost]
    @experience.category = params[:categories]
    @experience.save
    redirect_to new_experience_subexperience_path(experience_id: @experience.id)
  end

  def create_reviewed_exp_array(experiences)
      reviewed_exp = []
      experiences.each do |exp|
        reviewed_exp << exp if exp.subexperiences != []
      end
      reviewed_exp
  end

  def define_focused_experience(non_reviewed_experiences, clicked_exp_id, first_experience)
    # the one clicked
    if !clicked_exp_id.nil?
      focused_exp = Experience.find(clicked_exp_id)
    # The first that is not reviewed
    elsif non_reviewed_experiences != []
      focused_exp = non_reviewed_experiences.first
    # The first one
    else
      focused_exp = first_experience
    end
  end

  def put_first_exp_first_in_array(experience, experiences)
    experiences.delete(experience)
    experiences = experiences.insert(0,experience)
  end

end
