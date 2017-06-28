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
    update_recos
    @experiences = current_member.experiences.to_a
    @reviewed_experiences = create_reviewed_exp_array(@experiences)
    @non_reviewed_experiences = @experiences - @reviewed_experiences
    @clicked_exp_id = params[:clicked] || nil
    @experience = define_focused_experience(@non_reviewed_experiences, @clicked_exp_id, @experiences.first)
    put_first_exp_first_in_array(@experience, @experiences)
    @categories = ["Honeymoon", "Road trip", "Family friendly", "Nature/ Sport", "Cultural", "Relaxing", "Big fiesta", "Local immersion"]
    @checked_categories = define_checked_cat(@experience, @categories)
    @profile_title = define_title(@reviewed_experiences, @experiences, @experience)
    @recos = []
    current_member.recos.each do |reco|
      @recos << Region.find_by_name(reco)
    end
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

  def define_checked_cat(experience, categories)
    checked_categories = []
    if !experience.category.nil?
      experience.category.each do |cat|
        checked_categories << cat
      end
    end
    checked_categories
  end

  def define_title(reviewed_experiences, experiences, experience)
    if reviewed_experiences.count == experiences.count
      "You have completed feedbacks for all the countries you selected"
    elsif reviewed_experiences ==[]
      "Let's start with #{experience.region.name}"
    else
      "Let's continue with #{experience.region.name}"
    end
  end

  def update_recos
    @experiences = current_member.experiences.to_a
    @recos = get_recos(@experiences)
    current_member.recos = @recos.first(4)
    current_member.save
  end

  def get_recos(reviewed_experiences)

    classification = {'Croatia' => "sun", 'South of France' => "sun", 'Corsica' => "sun", 'Sardinia' => "sun", 'Sicily' => "sun",
      'Greece' => "sunandvisits", 'Portugal' => "sunandvisits", 'North of Italy' => "sunandvisits", 'Northern Spain' => "sunandvisits", 'South of Italy' => "sunandvisits",
      'Ireland' => "roadtrip", 'Scotland' => "roadtrip", 'Romania' => "roadtrip", 'Andalucia' => "roadtrip"
    }

    named_reviewed_experiences = []
    reviewed_categories = Set.new []
    reviewed_experiences.each do |exp|
      named_reviewed_experiences << exp.region.name
      reviewed_categories << classification[exp.region.name]
    end

    reviewed_categories.to_a
    gross_recos = []

    reviewed_categories.each do |category|
      gross_recos << classification.map{ |k,v| v==category ? k : nil }.compact
    end
    gross_recos = gross_recos.flatten
    named_recos = gross_recos.delete_if {|reco| named_reviewed_experiences.include?(reco)}
    named_recos
  end

  def get_names(reviewed_experiences)
    names = []
    reviewed_experiences.each do |exp|
      names << exp.region.name
    end
  end

end
