Spree::Store.class_eval do
  has_many :store_price_books
  has_many :price_books, -> { order('spree_store_price_books.priority ASC') }, through: :store_price_books
end
