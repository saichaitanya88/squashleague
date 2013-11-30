SquashLeague::Application.routes.draw do
  root  'home#index'
  resources :sessions, only: [:new, :create, :destroy]
  
  get "users/login"
  get "players/get_player"
  get "users/get_user"
  
  #post "users/create"
  
  get "league/home"
  get "league/players"
  get "league/schedule"
  get "league/player_history"
  get "league/history"
  
  get "users/dashboard_main"
  
	get "admin/admin_dashboard"
	get "admin/match_controls"
	get "admin/new_season"
	post "admin/create_season"
	get "admin/manage_seasons"
	get "admin/new_player"
	post "admin/manage_player"
	get "admin/manage_players"
	get "admin/new_user"
	post "admin/manage_user"
	get "admin/manage_users"
	post "admin/create_user"
	post "admin/create_player"
	post "admin/reset_user_password"
	
	match '/news', to: 'home#news', via: 'get'

  get "match/show"
  patch "match/edit"
	
	#	match '/signup', to: 'users#signup', via: 'get'
	match '/signin', to: 'sessions#new', via: 'get'
	match '/signout', to: 'sessions#destroy', via: 'delete'
	
  get "users/settings"
  post "users/update_details"
  post "users/update_password"
  
  post "post/create"
  get "post/show"
  get "post/new"
  patch "post/update"
  delete "post/delete"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
