class Search < ApplicationRecord
 has_many :trips
 belongs_to :region
 validates :starts_on, presence: true
 validates :returns_on, presence: true
 validates :city, presence: true
 validates :region, presence: true

 validate :infants_inf_adults

 private

 def infants_inf_adults
  unless (nb_infants <= nb_adults)
    errors.add(:base, "Number of infants can not be higher than adults")
  end
 end


end
