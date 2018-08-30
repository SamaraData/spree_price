Spree::Role.class_eval do
  has_many :role_price_books
  has_many :price_books, through: :role_price_books

  def self.create_default
    user = find_or_initialize_by(name: 'user')
    user.default = true
    user.save!
  end

  def self.default
    default = where(default: true).first
    default || create_default
  end
end
