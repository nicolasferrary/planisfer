class User < ApplicationRecord
  serialize :passengers
  has_many :orders

end
