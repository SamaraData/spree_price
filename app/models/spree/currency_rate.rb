class Spree::CurrencyRate < Spree::Base
  validates :base_currency, presence: true
  validates :currency, presence: true, uniqueness: { scope: :base_currency }
  validates :exchange_rate, presence: true
  validate :validate_single_default

  def self.create_default
    create(base_currency: Spree::Config[:currency], currency: Spree::Config[:currency], default: true)
  end

  def self.default
    if default = where(default: true).first
      default
    else
      create_default
    end
  end

  def self.update_from_open_exchange
    oxr = Money::Bank::OpenExchangeRatesBank.new
    oxr.app_id = Rails.application.config.openExchangeRate[:appId]
    oxr.update_rates
    oxr.cache = 'tmp/cache.json'
    oxr.ttl_in_seconds = 86400
    oxr.source = Spree::CurrencyRate.default.currency
    Money.default_bank = oxr

    Spree::Config[:supported_currencies].split(',').each do |currencyCode|
      logger.debug "Fetching currency #{currencyCode} from OpenExchange"
      currency = Money::Currency.new(currencyCode)
      rate = Money.default_bank.get_rate(Spree::CurrencyRate.default.currency, currency)
      currencyRate = Spree::CurrencyRate.find_or_create_by(
        base_currency: Spree::CurrencyRate.default.currency,
        currency: currency.iso_code,
        default: (Spree::Config[:currency] == currency.iso_code)
      )
      currencyRate.update_attribute(:exchange_rate, rate) if currencyRate
      logger.debug "Currency #{currencyCode} rate updated: #{rate}"
    end
  end

  private
  def validate_single_default
    return unless default?

    matches = self.class.where(default: true)

    if persisted?
      matches = matches.where('id != ?', id)
    end

    if matches.exists?
      errors.add(:default, 'cannot have multiple defaults.')
    end
  end
end
