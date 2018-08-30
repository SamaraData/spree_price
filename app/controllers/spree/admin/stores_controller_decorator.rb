Spree::Admin::StoresController.class_eval do
  def update_price_book_positions
    Spree::PriceBook.transaction do
      params[:positions].each do |id, index|
        Spree::StorePriceBook
          .where(price_book_id: id, store_id: params[:id])
          .update_all(priority: index)
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_stores_url(params[:id]) }
      format.js { render plain: 'Ok' }
    end
  end
end