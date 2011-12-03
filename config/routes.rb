Undersky::Application.routes.draw do
  get "comments/comments"

  get "comments/create_comment"

  get "comments/delete_comment"

  root to: "media#popular", as: :index

  controller :authorize do
    get "authorize",    as: :authorize
    get "access_token", as: :access_token
    get "logout",       as: :logout
  end

  get "users/feed(/max_id/:max_id)"            => "users#feed",   as: :feed
  get "users/liked(/max_like_id/:max_like_id)" => "users#liked",  as: :liked
  get "users/self"                             => "users#self",   as: :profile
  get "users/:id(/max_id/:max_id)"             => "users#recent", as: :recent

  get    "media/:id/likes" => "likes#likes",  as: :likes
  post   "media/:id/likes" => "likes#like",   as: :like
  delete "media/:id/likes" => "likes#unlike", as: :unlike

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
  # match ':controller(/:action(/:id(.:format)))'
end
