Spree::Order.class_eval do
  has_many :order_prices

  def user_roles
    user.try(:roles) || [Spree::Role.default]
  end

  def price_by_price_type(price_type)
    price = order_prices.find do |order_price|
      order_price.price_type_id == price_type.id
    end

    price || order_prices.build(price_type: price_type)
  end
end