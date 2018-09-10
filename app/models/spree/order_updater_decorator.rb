Spree::OrderUpdater.class_eval do
  def update_prices
    line_items.each do |line_item|
      line_item.update_price
      line_item.save!
    end

    Spree::PriceType.all.each do |price_type|
      order_price = order.price_by_price_type(price_type)
      order_price.amount = line_items.reduce(0) do |sum, line_item|
        sum + (line_item.line_item_price_by_price_type(price_type).amount * line_item.quantity)
      end
      order_price.save!
    end
  end

  def persist_totals
    update_prices

    order.update_columns(
      payment_state: order.payment_state,
      shipment_state: order.shipment_state,
      item_total: order.item_total,
      item_count: order.item_count,
      adjustment_total: order.adjustment_total,
      included_tax_total: order.included_tax_total,
      additional_tax_total: order.additional_tax_total,
      payment_total: order.payment_total,
      shipment_total: order.shipment_total,
      promo_total: order.promo_total,
      total: order.total,
      updated_at: Time.current,
    )
  end
end