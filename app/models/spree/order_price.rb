class Spree::OrderPrice < Spree::Base
  belongs_to :order
  belongs_to :price_type
end