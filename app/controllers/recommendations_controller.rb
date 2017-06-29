class RecommendationsController < ApplicationController
  def show
    update_member_status
    @recos_names = current_member.recos
    @recos = identify_regions(@recos_names)
  end

  def identify_regions(recos_names)
    recos = []
    recos_names.each do |name|
      recos << Region.find_by_name(name)
    end
    recos
  end

end

