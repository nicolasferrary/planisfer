class Order < ApplicationRecord
  monetize :amount_cents
end
