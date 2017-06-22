class ExperiencesController < ApplicationController

  def create_experiences
    # For each region in params, create an experience
    @regions = params
    # Renvoyer vers la new de la première expérience
  end
end
