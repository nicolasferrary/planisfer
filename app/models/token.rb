class Token < ApplicationRecord
  validates :text, presence: true
end
