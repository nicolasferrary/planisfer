class SubexperiencesController < ApplicationController

  def new
    @experience = Experience.find(params[:experience_id])
    @experiences = current_member.experiences.to_a
    @experience = Experience.find(params[:experience_id])
    @experiences.delete(@experience)
    @experiences.insert(0, @experience)

    @region = @experience.region
    @pois = @experience.region.pois
  end

end
