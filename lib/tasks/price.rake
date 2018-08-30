namespace :spree_price do
  desc "Set default currency rates from OpenExchange"
  task :currency_rates => :environment do
    Spree::CurrencyRate.update_from_open_exchange
  end

  task :initialize_price_books => :environment do
    Spree::CurrencyRate.update_from_open_exchange

    # Initialize price type
    if Spree::PriceType.count == 0
      Spree::PriceType.create!(name: 'Selling Price', code: 'selling', default: true)
      Spree::PriceType.create!(name: 'Marked Price', code: 'marked')
      Spree::PriceType.create!(name: "Manufacturer's Suggested Retail Price", code: 'msrp')
    end

    # Try initializing default role
    role = Spree::Role.where(name: 'user').first
    if role
      role.default = true
      role.save
    end

    # Initialize default price book for every currency
    selling_price_type = Spree::PriceType.first
    Spree::Config[:supported_currencies].split(',').map do |currency|
      price_book = Spree::PriceBook.where(currency: currency).first
      
      if price_book.nil?
        if Spree::Config[:currency] != currency
          parent_price_book = Spree::PriceBook.where(currency: Spree::Config[:currency]).first
        else 
          parent_price_book = nil
        end

        Spree::PriceBook.create!(
          currency: currency,
          active_from: 1.month.ago,
          active_to: 1.month.from_now,
          name: "Default #{currency}",
          parent: parent_price_book,
          price_type: selling_price_type,
          roles: Spree::Role.all,
          stores: Spree::Store.all
        )
      end
    end

    # Move price to corresponding price book
    Spree::Config[:supported_currencies].split(',').map do |currency|
      price_book = Spree::PriceBook.where(currency: currency).first
      if price_book
        Spree::Price.where(price_book_id: nil, currency: currency)
          .update_all(price_book_id: price_book.id)
      end
    end
  end
end
