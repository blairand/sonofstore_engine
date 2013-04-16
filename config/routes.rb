require 'resque/server'

StoreEngine::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"
  resource :customers,          except: [:index]
  resources :addresses
  resources :shipping_addresses
  resources :orders,             only:   [:show, :index]
  resources :customer_sessions,  only:   [:new, :create, :destroy]
  resources :cart_products,      only:   [:destroy]
  resources :shipping_addresses, except: [:index]

  namespace :admin do
    resources :stores, only: [:show, :destroy, :update, :index]
    resources :customers, only: [:index, :show, :destroy]
    # resources :products, only: [:index, :show, :create, :update, :destroy] 
  end

  get '/account' => 'customers#show'
  get '/signup' => 'customers#new'

  resources :stores
  put '/stores/:id/status' => 'stores#change_status', :as => 'change_store_status'
  root to: 'stores#landing'

  match 'login'  => 'customer_sessions#new'
  match 'logout' => 'customer_sessions#destroy'
  match '/code'   => redirect('https://github.com/blairand/sonofstore_engine')

  scope '/:store_path' do
    put '/administer'  => 'admin/stores#administer', :as => 'administer'
    get '/admin' => 'store_admin/stores#show', as: 'store_admin'
    get '/admin/store/edit' => 'store_admin/stores#edit', as: 'store_admin_edit_store'
    put '/admin/store/edit' => 'store_admin/stores#update', as: 'store_admin_edit_store'

    get '/admin/store/products' => 'store_admin/products#index', as: 'store_admin_products'
    get '/admin/store/products/:id' => 'store_admin/products#show', as: 'store_admin_product'
    get '/admin/store/products/new' => 'store_admin/products#new', as: 'store_admin_new_product'
    post '/admin/store/products/new' => 'store_admin/products#create', as: 'store_admin_new_product'
    get '/admin/store/products/:id/edit' => 'store_admin/products#edit', as: 'store_admin_edit_product'
    put '/admin/store/products/:id/edit' => 'store_admin/products#update', as: 'store_admin_edit_product'
    delete '/admin/store/products/:id' => 'store_admin/products#destroy', as: 'store_admin_delete_product'

    get '/stock/products' => 'store_stocker/products#index', as: 'store_stocker_products'
    get '/stock/products/:id' => 'store_stocker/products#show', as: 'store_stocker_product'
    # get '/stock/products/new' => 'store_stocker/products#new', as: 'store_stocker_new_product'
    post '/stock/products/create' => 'store_stocker/products#create', as: 'store_stocker_new_product'
    # get '/stock/products/:id/edit' => 'store_stocker/products#edit', as: 'store_stocker_edit_product'
    put '/stock/products/:id/edit' => 'store_stocker/products#update', as: 'store_stocker_edit_product'
    


    # cool-sunglasses/stock/products 'store_stocker/products#index' as: store_stocker_products

    match '/' => 'stores#show', as: 'home'
    get '/orders/:url_token' => 'orders#unique_order_confirmation', as: 'url_token'
    resource :carts
    resources :categories,         only:   [:show, :index]
    resources :products,           only:   [:show, :index]
    resources :charges,            only:   [:new, :create]
    get '/checkout_options' => 'charges#checkout_options'
    post '/create_guest' => 'charges#create_guest'

  end
end
