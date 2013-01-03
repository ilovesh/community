Dragon::Application.routes.draw do
  root to: 'basics#home'
  resources :users, :votes
  resources :sessions, only: [:new, :create, :destroy]
  resources :courses do
    collection do
      get :autocomplete_name
    end
    resources :reviews,  only: [:new, :create, :index]
    resources :notes,    only: [:new, :create, :index]
  end
  resources :reviews, only: [:show, :edit, :update, :destroy]
  resources :notes, only: [:show, :edit, :update, :destroy]

  resources :lists do
    resources :comments, only: [:create, :update, :destroy]
  end

  resources :likes, only: [:create, :destroy]
  resources :enrollments, only: [:create, :destroy]
  resources :listings, only: [:create, :update, :destroy]

  resources :discussions do
    resources :comments, only: [:create, :update, :destroy]
  end

  match '/signup', to: 'users#new'
  match '/login',  to: 'sessions#new'
  match '/logout', to: 'sessions#destroy', via: :delete
  match '/search', to: 'basics#search'
  match '/courses/tagged/:tag', to: 'courses#tagged'
  match '/lists/tagged/:tag',   to: 'lists#tagged'
  match '/discussions/tagged/:tag',   to: 'discussions#tagged'  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
