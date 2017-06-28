class Experience < ApplicationRecord
  belongs_to :member
  belongs_to :region
  has_many :subexperiences
end
