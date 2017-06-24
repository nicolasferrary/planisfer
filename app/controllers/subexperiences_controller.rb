class SubexperiencesController < ApplicationController

  def new
    @experiences = current_member.experiences.to_a
    @experience = Experience.find(params[:experience_id])
    @experiences.delete(@experience)
    @experiences.insert(0, @experience)

    @region = @experience.region
    @pois =[]
    @experience.region.pois.each do |poi_string|
      @pois << Poi.find_by_name(poi_string)
    end

    @nb_rows = @pois.count.fdiv(2).round
    @even_pois = @pois.count.even?
    @pois_hash = define_pois_hash(@pois, @nb_rows, @even_pois)
  end

  def create
    @subexperience = Subexperience.new()

    @experience = Experience.find(params[:experience_id])
    @subexperience.experience = @experience

    @poi = Poi.last
    @subexperience.poi = @poi

    @subexperience.rating = params[:rating]
    @subexperience.review = params[:review]

    @subexperience.save!
  end

  def define_pois_hash(pois, nb_rows, boolean)
    pois_hash = {}
    (0..(nb_rows-2)).each do |number|
      pois_hash[number] = [pois[number*2], pois[number*2+1]]
    end
    if boolean
      pois_hash[nb_rows-1] = [pois[(nb_rows-1)*2], pois[(nb_rows-1)*2+1]]
    else
      pois_hash[nb_rows-1] = [pois[(nb_rows-1)*2]]
    end
    pois_hash
  end

end
