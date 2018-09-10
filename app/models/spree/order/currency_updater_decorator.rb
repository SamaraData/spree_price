Spree::Order::CurrencyUpdater.class_eval do
  def update_line_item_currencies!
    line_items.where('currency != ?', currency).each do |line_item|
      line_item.update_attributes!(currency: currency)
      line_item.update_price
      # TODO: association is not saving with line_item.save!
      line_item.line_item_prices.collect(&:save!)
      line_item.save!
    end

    updater.update_prices
  end
end