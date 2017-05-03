class Search < ApplicationRecord
 has_many :trips
 belongs_to :region

 validates :starts_on, presence: true
 validates :returns_on, presence: true
 validates :nb_travelers, presence: true
 validates :city, presence: true
 validates :region, presence: true

end
