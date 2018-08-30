FactoryGirl.define do
  factory :currency_rate, class: 'Spree::CurrencyRate' do
    base_currency { Spree::Config[:currency] }
    currency { Spree::Config[:currency] }
    exchange_rate 1

    factory :foreign_currency_rate do 
      currency { Faker::Currency.code }
      exchange_rate { Faker::Number.decimal(2, 3) }
    end
    factory :default_currency_rate do
      default true
    end
  end
end
