Spree::Admin::PricesController.class_eval do
  before_action :load_extra, only: [:index, :variant_prices]

  def load_extra
    @store = params[:store_id] ? Spree::Store.find(params[:store_id]) : Spree::Store.first
    @price_type = params[:price_type_id] ? Spree::PriceType.find(params[:price_type_id]) : Spree::PriceType.first
    @role = params[:role_id] ? Spree::Role.find(params[:role_id]) : Spree::Role.first
  end

  def variant_prices
    @product = Spree::Product.friendly.find(params[:product_id])

    variant_prices_params.each do |variant_id, price_params|
      price_params.each do |currency, amount|
        if amount.present?
          price_book = @store
            .price_books
            .by_currency(currency.upcase)
            .by_price_type(@price_type.try(:id))
            .by_roles([@role.try(:id)])
            .first
          price_book = price_book || Spree::PriceBook
            .by_currency(currency)
            .by_price_type(@price_type.try(:id))
            .first

          price = Spree::Price.find_or_initialize_by(
            currency: currency.upcase,
            variant_id: variant_id,
            price_book_id: price_book.try(:id)
          )

          price.amount = amount.to_f
          price.save!
        end
      end
    end

    flash[:success] = Spree.t('notice_messages.variant_price_updated')
    redirect_to admin_product_prices_path(
      @product,
      store_id: @store.try(:id),
      role_id: @role.try(:id),
      price_type_id: @price_type.try(:id)
    )
  end

  private
  def variant_prices_params
    params.require(:vp).tap do |whitelisted|
      whitelisted = params[:vp]
    end
  end
end