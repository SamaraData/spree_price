class Spree::RolePriceBook < Spree::Base
  belongs_to :price_book
  belongs_to :role
  delegate :name, to: :price_book
end
