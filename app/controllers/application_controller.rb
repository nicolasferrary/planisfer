class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_member!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
  { host: ENV['HOST'] || 'localhost:3000' }
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb

  end

  def update_member_status
    started_exp
    some_incomplete_experiences
    member = current_member
    if member.experiences.count == 0
      member.profile_status =0
    elsif !started_exp && member.subexperiences.count == 0
      member.profile_status = 25
    elsif started_exp && member.subexperiences.count == 0
      member.profile_status = 50
    elsif some_incomplete_experiences # some experiences don't have any subexp
      member.profile_status = 75
    else
      member.profile_status = 100
    end
    member.save
  end

  def started_exp
    # at least one experience has some attributes filled
    started_exp = false
    experiences = current_member.experiences
    experiences.each do |exp|
      if !exp.cost.nil? || !exp.length.nil? || exp.category != []
        started_exp = true
      end
    end
    started_exp
  end

  def some_incomplete_experiences
    some_incomplete_experiences = false
    experiences = current_member.experiences
    experiences.each do |exp|
      if exp.subexperiences == []
        some_incomplete_experiences = true
      end
    end
    some_incomplete_experiences
  end

end
