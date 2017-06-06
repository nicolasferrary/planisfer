class Order < ApplicationRecord
  monetize :amount_cents
  belongs_to :member, optional: true
end
