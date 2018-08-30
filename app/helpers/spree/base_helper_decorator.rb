Spree::BaseHelper.class_eval do
  def supported_currencies_options
    supported_currencies.map do |currency|
      iso = currency.iso_code
      ["#{currency.name} (#{iso})", iso]
    end
  end

  def price_types_options
    Spree::PriceType.all.map do |price_type|
      ["#{price_type.name} (#{price_type.code})", price_type.id]
    end
  end

  def stores_options
    Spree::Store.all.map do |store|
      ["#{store.name} (#{store.code})", store.id]
    end
  end

  def roles_options
    Spree::Role.all.map do |role|
      [role.name, role.id]
    end
  end

  def roles_to_s(roles)
    if roles && !roles.empty?
      roles.map(&:name).join(', ')
    end
  end
end
