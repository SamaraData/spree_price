Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :currency_rates do
      collection do
        get :fetch
      end
    end

    resources :price_books do
      member do 
        patch :update_price
        patch :add_price
        get :load_from_parent
      end
    end

    resources :price_types

    resources :stores do
      member do
        post :update_price_book_positions
      end
    end

    resources :products do
      resources :prices do
        collection do 
          post :variant_prices
        end
      end
    end
  end
end
