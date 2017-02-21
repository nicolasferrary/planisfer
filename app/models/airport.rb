class Airport < ApplicationRecord
 belongs_to :city
 belongs_to :region
 validates :name, presence: true
 validates :iata, presence: true
end
