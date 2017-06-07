class Order < ApplicationRecord
  monetize :amount_cents
  serialize :passengers
  belongs_to :member, optional: true
end
