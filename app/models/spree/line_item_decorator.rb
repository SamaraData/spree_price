Spree::LineItem.class_eval do
  has_many :line_item_prices, validate: true

  def user_roles_for_price
    order ? order.user_roles : Spree::Store.current_user.try(:roles) || [Spree::Role.default]
  end

  def store_for_price
    order ? order.store : Spree::Store.current_store
  end

  def currency_for_price
    order ? order.currency : Spree::Store.current_currency
  end

  def variant_price_by_price_type(price_type, currency = currency_for_price)
    variant.price_in(currency, store_for_price, user_roles_for_price, price_type)
  end

  def line_item_price_by_price_type(price_type)
    line_item_price = line_item_prices.find do |line_item_price|
      line_item_price.price_type_id == price_type.id
    end
    line_item_price || line_item_prices.build({ price_type_id: price_type.id })
  end

  def default_line_item_price
    line_item_prices.find { |line_item_price| line_item_price.price_type.default? }
  end
  
  def update_default_price
    default_price = default_line_item_price

    if default_price
      self.currency = order.currency if order
      self.price = default_price.amount
    end
  end

  def update_line_item_prices
    Spree::PriceType.all.each do |price_type|
      yield(variant_price_by_price_type(price_type), price_type)
    end
  end

  def update_price
    update_line_item_prices do |variant_price, price_type|
      line_item_price = line_item_price_by_price_type(price_type)

      if order
        line_item_price.amount = variant_price.price_including_vat_for(tax_zone: tax_zone)
      else 
        line_item_price.amount = variant_price.amount
      end
    end

    update_default_price
  end

  def update_price_from_modifier(currency, opts)
    self.currency = currency if currency

    update_line_item_prices do |variant_price, price_type|
      line_item_price = line_item_price_by_price_type(price_type)

      if currency
        line_item_price.amount = 
          variant_price_by_price_type(price_type, currency).amount + 
          variant.price_modifier_amount_in(currency, opts)
      else
        line_item_price.amount =
          variant_price_by_price_type(price_type).amount + 
          variant.price_modifier_amount(opts)
      end
    end

    update_default_price
  end
end
