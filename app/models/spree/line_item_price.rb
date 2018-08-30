class Spree::LineItemPrice < Spree::Base
  belongs_to :line_item
  belongs_to :price_type
end