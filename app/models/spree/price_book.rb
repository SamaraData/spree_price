class Spree::PriceBook < Spree::Base
  acts_as_nested_set

  has_many :role_price_books
  has_many :roles, class_name: 'Spree::Role', through: :role_price_books
  has_many :prices
  
  has_many :store_price_books
  has_many :stores, through: :store_price_books
  has_many :variants, through: :prices

  belongs_to :price_type

  validates :active_to, timeliness: { after: :active_from, allow_blank: true }
  validates :currency, presence: true

  before_save :set_price_adjustment_factor
  accepts_nested_attributes_for :prices

  scope :active, -> {
    where("(#{table_name}.active_from <= ? AND (#{table_name}.active_to IS NULL OR #{table_name}.active_to >= ?))",
      Time.zone.now, Time.zone.now)
  }
  scope :by_currency, -> (currency_iso) { where(currency: currency_iso) }
  scope :by_roles, lambda { |role_ids|
    compacted_ids = role_ids.try(:compact)
    unless compacted_ids.nil? || compacted_ids.empty?
      includes(:role_price_books).where(spree_role_price_books: { role_id: compacted_ids })
    else 
      where(nil)
    end
  }
  scope :by_store, lambda { |store_id|
    if store_id.present?
      includes(:store_price_books).where(spree_store_price_books: { store_id: store_id })
    else
      where(nil)
    end
  }
  scope :by_price_type, lambda { |price_type_id|
    if price_type_id.present?
      where(price_type_id: price_type_id)
    else
      where(nil)
    end
  }
  scope :explicit, -> { where(parent_id: nil, price_adjustment_factor: nil) }
  
  def explicit?
    parent_id.blank?
  end

  def factored?
    parent_id.present?
  end

  def active?
    active_from <= Time.zone.now && (active_to.nil? || active_to >= Time.zone.now)
  end

  def load_prices_from_parent(force_update = false)
    return if explicit?

    parent.prices.each do |parent_price|
      price = prices.find_or_initialize_by(
        currency: currency,
        variant_id: parent_price.variant_id,
      )

      if force_update || price.new_record?
        price.amount = parent_price.amount * price_adjustment_factor
        price.save!
      end
    end
  end

  def set_price_adjustment_factor
    if price_adjustment_factor.blank?
      if parent.present? && parent.currency != currency && 
        self.price_adjustment_factor = Spree::CurrencyRate
          .find_by(base_currency: parent.currency, currency: currency)
          .try(:exchange_rate)
      else
        self.price_adjustment_factor = 1.0
      end
    end
  end
end