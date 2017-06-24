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

    @subexperiences = @experience.subexperiences
    @saved_subexp = build_subexp_hash(@subexperiences)
    @rating_status = update_rating_status(@pois, @subexperiences)
      # build a hash with pois and numbers
  end

  def create
    @poi = Poi.find(params[:poi_id])
    @experience = Experience.find(params[:experience_id])
    @rating = params[:rating]
    @review = params[:review]

    pois = []
    @experience.subexperiences.each do |subexp|
      pois << subexp.poi
    end

    if pois.include?(@poi)
      @subexperience = Subexperience.find_by_poi_id(@poi.id)
      update_subexp(@subexperience, @rating, @review)
    else
      create_new_subexp(@experience, @poi, @rating, @review)
    end

    redirect_to new_experience_subexperience_path(experience_id: @experience.id)
  end

  def create_new_subexp(experience, poi, rating, review)
    subexperience = Subexperience.new()
    subexperience.experience = experience
    subexperience.poi = poi
    subexperience.rating = rating
    subexperience.review = review
    subexperience.save
  end

  def update_subexp(subexperience, rating, review)
    subexperience.rating = rating
    subexperience.review = review
    subexperience.save
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

  def build_subexp_hash(subexperiences)
    subexp_hash = {}
    subexperiences.each do |subexp|
      poi_id = subexp.poi.id
      subexp_hash[poi_id.to_s] = subexp
    end
    subexp_hash
  end

  def update_rating_status(pois, saved_subexp)
    rating_status = {}
    pois.each do |poi|
      rating_status[poi.id.to_s] = {}
      (1..5).each do |nb|
        if !@saved_subexp.has_key?(poi.id.to_s)
          rating_status[poi.id.to_s][nb.to_s] = false
        elsif @saved_subexp[poi.id.to_s].rating == nb
          rating_status[poi.id.to_s][nb.to_s] = true
        else
          rating_status[poi.id.to_s][nb.to_s] = false
        end
      end
    end
    rating_status
  end

end
