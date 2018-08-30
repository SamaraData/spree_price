class Spree::StorePriceBook < Spree::Base
  default_scope { order(:priority) }

  belongs_to :price_book
  belongs_to :store
  delegate :name, to: :price_book
end
