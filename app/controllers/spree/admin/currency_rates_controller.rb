module Spree
  module Admin
    class CurrencyRatesController < Spree::Admin::ResourceController
      def fetch
        Spree::CurrencyRate.update_from_open_exchange
        flash[:success] = Spree.t('notice_messages.currency_rate_fetched')
        redirect_to admin_currency_rates_path
      end
    end
  end
end
