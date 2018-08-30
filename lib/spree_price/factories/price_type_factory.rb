FactoryGirl.define do
  factory :price_type, class: 'Spree::PriceType' do
    name "#{FFaker::Name.first_name} Price"
    priority FFaker::Random.rand(0..9)

    factory :selling_price_type do
      name 'Selling Price'
      priority 0
    end

    factory :marked_price_type do
      name 'Marked Price'
      priority 1
    end

    factory :msr_price_type do
      name 'MSR Price'
      priority 2
    end
  end
end
