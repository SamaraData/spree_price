Spree::Variant.class_eval do
  has_many :prices, dependent: :destroy, inverse_of: :variant
  has_many :price_books, -> { active }, through: :prices

  def price_in_price_book(
    currency = Spree::Store.current_currency,
    store = Spree::Store.current_store,
    roles = Spree::Store.current_user.try(:roles) || [Spree::Role.default],
    price_type = nil
  )
    prices
      .by_currency(currency)
      .by_roles(roles)
      .by_store(store)
      .by_price_type(price_type)
      .first
  end

  def price_in(
    currency = Spree::Store.current_currency,
    store = Spree::Store.current_store,
    roles = Spree::Store.current_user.try(:roles) || [Spree::Role.default],
    price_type = nil
  )
    price_book_price = price_in_price_book(currency, store, roles, price_type)

    logger.warn("Variant #{sku} price cannot be found in store #{store.try(:code)} "\
      "in #{currency} with roles #{roles.compact.try(:flat_map, &:name)}") if price_book_price.nil?

    price_book_price ||
    prices.by_currency(currency).by_price_type(price_type).first ||
    prices.by_currency(currency).first
  end

  def price_by_price_type(price_type)
    price_in(
      Spree::Store.current_currency,
      Spree::Store.current_store,
      Spree::Store.current_user.try(:roles),
      price_type
    )
  end
end
