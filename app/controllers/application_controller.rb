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

end
