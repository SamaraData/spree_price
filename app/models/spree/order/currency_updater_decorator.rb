Spree::Order::CurrencyUpdater.class_eval do
  def update_line_item_currencies!
    line_items.where('currency != ?', currency).each do |line_item|
      line_item.update_attributes!(currency: currency)
      line_item.update_price
      line_item.save!
    end
  end
end