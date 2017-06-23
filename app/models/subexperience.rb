class Subexperience < ApplicationRecord
  belongs_to :experience
  belongs_to :poi
  has_many :activities
end
