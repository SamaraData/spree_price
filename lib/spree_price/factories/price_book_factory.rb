FactoryGirl.define do
  factory :price_book, :class => 'Spree::PriceBook' do
    currency { Spree::Config[:currency] }
    name 'Generic Price Book'

    factory :active_price_book do
      active_from 1.month.ago
      active_to 1.month.from_now

      factory :explicit_price_book do
        name 'Explicit'
      end

      factory :factored_price_book do
        name 'Factored'
        parent { create(:explicit_price_book) }
        currency { FFaker::Currency.code }
        price_adjustment_factor 2.5
        priority 10
      end

      factory :store_price_book do
        after(:create) { |book| create(:store, price_books: [book]) unless book.stores.present? }
      end
    end
  end

  factory :spree_store_price_book, :class => 'Spree::StorePriceBook' do
    price_book
    store
    active false
    priority 1
  end
end
