class Subexperience < ApplicationRecord
  belongs_to :experience
  belongs_to :poi
  belongs_to :activity
end
