class ProfilesController < ApplicationController
  def show
    @member = current_member
    @regions = Region.all
  end

end
