class Search < ApplicationRecord
 has_many :trips

 validates :starts_on, presence: true
 validates :returns_on, presence: true
 validates :nb_travelers, presence: true
 validates :city, presence: true
 validates :region, presence: true

end
