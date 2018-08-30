module Spree
  module Admin
    class PriceBooksController < Spree::Admin::ResourceController
      def show
        @prices = @price_book
          .prices
          .includes(variant: [{ option_values: :option_type }, :product])
          .page(params[:page])
      end

      def update_price
        @price_book.update_attributes(prices_params)
        redirect_to admin_price_book_path(@price_book)
      end

      def add_price
        prices_params[:prices_attributes].each do |price_param|
          price = @price_book.prices.find_or_initialize_by(
            currency: @price_book.currency,
            variant_id: price_param[:variant_id].to_i,
          )
          price.amount = price_param[:amount].to_f
          price.save!
        end
        redirect_to admin_price_book_path(@price_book)
      end

      def load_from_parent
        @price_book.load_prices_from_parent(!params[:force_update].nil?)

        flash[:success] = Spree.t('notice_messages.price_book_loaded_from_parent')
        redirect_to admin_price_book_path(@price_book)
      end

      private
      def prices_params
        params.require(:price_book).permit(prices_attributes: [:id, :amount, :variant_id])
      end
    end
  end
end
