class SubexperiencesController < ApplicationController

  def new
    @experiences = current_member.experiences.to_a
    @experience = Experience.find(params[:experience_id])
    @experiences.delete(@experience)
    @experiences.insert(0, @experience)
    @subexperiences = @experience.subexperiences

    @region = @experience.region
    @pois = define_pois_array(@experience, @subexperiences)

    @saved_subexp = build_subexp_hash(@subexperiences)
    @rating_status = update_rating_status(@pois, @saved_subexp)
    @star_full_hash = update_star_full_hash(@pois, @rating_status)
    @reviews = update_reviews(@subexperiences)
    @activities = update_activities(@subexperiences)
    @activity_reviews = update_activity_reviews(@subexperiences)
    @reviewed_pois = define_reviewed_pois(@pois, @subexperiences)
    @focused_poi = define_focused_poi(@pois, @reviewed_pois)
    @confirmable = true if @reviewed_pois[:rating_ok] != []
  end

  def create
    @experience = Experience.find(params[:experience_id])

    if check_name(params[:newpoiname], @experience)
      flash[:name_error] = "This destination already exists"

    else
      if params[:newpoiname]
        @poi = Poi.create(name: params[:newpoiname])
      else
        @poi = Poi.find(params[:poi_id])
      end

      pois = []
      @experience.subexperiences.each do |subexp|
        pois << subexp.poi
      end

      if pois.include?(@poi)
        @subexperience = Subexperience.find_by_poi_id(@poi.id)
        update_subexp(@subexperience, params)
      else
        create_new_subexp(@experience, @poi, params)
      end

    end

    redirect_to new_experience_subexperience_path(experience_id: @experience.id)

  end

  def create_new_subexp(experience, poi, params)
    @subexperience = Subexperience.new()
    @subexperience.experience = experience
    @subexperience.poi = poi
    @subexperience.rating = params[:rating]
    @subexperience.review = params[:review]
    create_activity(@subexperience, params) unless params [:activity_name] == "" || params [:activity_name].nil?
    @subexperience.save
  end

  def update_subexp(subexperience, params)
    subexperience.rating = params[:rating]
    subexperience.review = params[:review]
    if subexperience.activities != []
      update_activity(subexperience, params)
    elsif params [:activity_name] != ""
      create_activity(@subexperience, params)
    end

    subexperience.save
  end

  # def define_pois_hash(pois, nb_rows, boolean)
  #   pois_hash = {}
  #   (0..(nb_rows-2)).each do |number|
  #     pois_hash[number] = [pois[number*2], pois[number*2+1]]
  #   end
  #   if boolean
  #     pois_hash[nb_rows-1] = [pois[(nb_rows-1)*2], pois[(nb_rows-1)*2+1]]
  #   else
  #     pois_hash[nb_rows-1] = [pois[(nb_rows-1)*2]]
  #   end
  #   pois_hash
  # end

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

  def update_star_full_hash(pois, rating_status)
    star_full_hash = {}
    pois.each do |poi|
      star_full_hash[poi.id.to_s] = {}
      selected_nb = rating_status[poi.id.to_s].key(true).to_i
      if !selected_nb.nil?
        (1..selected_nb).each do |nb|
          star_full_hash[poi.id.to_s][nb.to_s] = true
        end
        if selected_nb < 5
          ((selected_nb+1)..5).each do |nb|
            star_full_hash[poi.id.to_s][nb.to_s] = false
          end
        end
      end
    end
    star_full_hash
  end

  def create_activity(subexperience, params)
    activity = Activity.new()
    activity.name = params[:activity_name]
    activity.review = params[:activity_review]
    activity.subexperience = subexperience
    activity.save
  end

  def update_activity(subexperience, params)
    activity = Activity.find_by_subexperience_id(subexperience.id)
    activity.name = params[:activity_name]
    activity.review = params[:activity_review]
    activity.save
  end

  def update_reviews(subexperiences)
    reviews = {}
    subexperiences.each do |subexp|
      poi = subexp.poi
      reviews[poi.id.to_s] = subexp.review
    end
    reviews
  end

  def update_activities(subexperiences)
    activities = {}
    subexperiences.each do |subexp|
      poi = subexp.poi
      activity = Activity.find_by_subexperience_id(subexp.id)
      if !activity.nil?
        activities[poi.id.to_s] = activity.name
      else
        activities[poi.id.to_s] = ""
      end
    end
    activities
  end

  def update_activity_reviews(subexperiences)
    activity_review = {}
    subexperiences.each do |subexp|
      poi = subexp.poi
      activity = Activity.find_by_subexperience_id(subexp.id)
      if !activity.nil?
        activity_review[poi.id.to_s] = activity.review
      else
        activity_review[poi.id.to_s] = ""
      end
    end
    activity_review
  end

  def  define_reviewed_pois(pois, subexperiences)
    reviewed_pois = {:rating_ok => [], :no_rating => []}
    subexperiences.each do |subexp|
      if subexp.rating.nil?
        reviewed_pois[:no_rating] << subexp.poi
      else
        reviewed_pois[:rating_ok] << subexp.poi
      end
    end
    reviewed_pois
  end

  def define_focused_poi(pois, reviewed_pois)
    #take the one clicked (in the params)
    if !params[:poi_id].nil?
      focused_poi = Poi.find(params[:poi_id])
    #if there are some subexp that don't have any feedback, focus on the last one create without any feedback
    elsif reviewed_pois[:no_rating] != []
      focused_poi = reviewed_pois[:no_rating].last
    # if there are some subexp already and they all have feedback, take the first one without feedback
    elsif reviewed_pois[:rating_ok] != []
      not_reviewed_pois = pois - reviewed_pois[:rating_ok]
      focused_poi = not_reviewed_pois.first
    #else, take the first poi
    else
      focused_poi = pois.first
    end
  end

  def create_new_poi
    poi = POI.new()
    poi.name = params[:newpoiname]
    poi.save
  end

  def define_pois_array(experience, subexperiences)
    pois = Set.new []
    experience.region.pois.each do |poi_string|
      pois << Poi.find_by_name(poi_string)
    end
    subexperiences.each do |subexp|
      pois << subexp.poi
    end
    pois.to_a
  end

  def check_name(name, experience)
    subexperiences = experience.subexperiences
    pois = define_pois_array(experience, subexperiences)
    pois = pois.map { |poi| poi.name }
    true if pois.include?(name)
  end

end
