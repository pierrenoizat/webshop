Depot::Application.routes.draw do
  get "contact_forms/new"

  get "contact_forms/create"

  get "pages/gallery"

  get "pages/faq"
  
  get "pages/coins"
  
  get "pages/shipping"

  get "pages/news"

  get "products/coins"

  get "products/cards"

  get "pages/checks"

  get "pages/about"

  get "pages/privacy"

  get "pages/tos"
  
  get "pages/tasks"
  
  get "pages/address"
  
  get "products/downloads"
  
  post "notification" => "invoices#notification"
  

  resources :invoices do
      member do
        post :download
        get  :download
        post :cancel_order
        get  :cancel_order
        get  :cancel_confirmed
        post  :confirm_payment
      end
    end

  resources :invoices do
	collection do
		post :notification
	end
	end


  get 'admin' => 'admin#index'
    controller :sessions do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end

  scope '(:locale)' do
    resources :users
	  resources :contact_forms
    resources :orders
    resources :line_items
    resources :carts
    resources :products do
      get :who_bought, :on => :member
    end

    root :to => "store#index", :as => 'store'
  end

  
end
