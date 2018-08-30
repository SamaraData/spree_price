Spree::Price.class_eval do
  default_scope { includes(:variant).order('spree_variants.sku') }

  belongs_to :price_book
  validate :ensure_proper_currency

  scope :by_currency, -> (currency_iso) { where(currency: currency_iso) }
  scope :by_roles, lambda { |role_ids|
    compacted_ids = role_ids.try(:compact)
    unless compacted_ids.nil? || compacted_ids.empty?
      includes(price_book: :role_price_books)
      .where(spree_role_price_books: { role_id: compacted_ids })
    else
      where(nil)
    end
  }
  scope :by_store, lambda { |store_id|
    if store_id.present?
      includes(price_book: :store_price_books)
      .where(spree_store_price_books: { store_id: store_id })
    else
      where(nil)
    end
  }
  scope :by_price_type, lambda { |price_type_id|
    if price_type_id.present?
      includes(:price_book)
      .where(spree_price_books: { price_type_id: price_type_id })
    else
      where(nil)
    end
  }

  def ensure_proper_currency
    if price_book && currency != price_book.currency
      errors.add(:currency, :match_price_book)
    end
  end
end