ProjectOctober::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # todo: make this ajax --> post 'subscriptions/verify'

  devise_for :users, :path => 'auth', :controllers => {
    :registrations => 'users',
    :sessions => 'home',
  }
  devise_scope :user do
    resources :users, :only => :show do
      resources :subscriptions, :only => [:create, :destroy]

      member do
        get 'follow'
        get 'unfollow'
        get 'keywords'
        resource :keywords, :only => [:create, :destroy], :controller => 'user_keywords'
      end
    end

    resources :feeds, :only => :show, :controller => 'users' do
      member do
        get 'follow'
        get 'unfollow'
      end
    end

    resources :posts, :id => /\d+/ do
      member do
        get 'upvote'
        get 'downvote'
        get 'debug'
        resources :comments
      end
      collection do
        post 'fetch'
        get 'recommendations'
      end
    end
  end

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
  devise_scope :user do
    root :to => 'home#index'
    get '/about' => 'home#about'
    match '/404', :to => 'errors#error_404'
    match '/500', :to => 'errors#error_500'
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
