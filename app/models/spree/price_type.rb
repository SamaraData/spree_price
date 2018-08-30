class Spree::PriceType < Spree::Base
  def self.create_default
    price_type = find_or_initialize_by(
      name: "Selling Price #{Spree::Config[:currency]}",
      code: 'selling'
    )
    price_type.default = true
    price_type.save!
  end

  def self.default
    default = where(default: true).first
    default || create_default
  end
end
