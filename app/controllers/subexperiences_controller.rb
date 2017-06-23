class SubexperiencesController < ApplicationController

  def new
    @experiences = current_member.experiences.to_a
    @experience = Experience.find(params[:experience_id])
    @experiences.delete(@experience)
    @experiences.insert(0, @experience)

    @region = @experience.region
    @pois = @experience.region.pois

    # params[:id].nil? ? @subexperience = Subexperience.new() : @subexperience = Subexperience.find(params[:id])
  end

  def create
    @subexperience = Subexperience.new()

    @experience = Experience.find(params[:experience_id])
    @subexperience.experience = @experience

    @poi = Poi.last
    @subexperience.poi = @poi

    @subexperience.review = params[:review]

    @subexperience.save!
  end

end
