Ketchup::Application.routes.draw do
  
  match 'pomodoros/update_current_form' => 'pomodoros#update_current_form'
  match 'todotodays/save_sort'          => 'todotodays#save_sort'

  resources :activities,  :pomodoros, :settings, :projects
  resources :users #,       :except => [:show]
  resources :breaks,      :only => [:create, :update]
  resources :todotodays,  :only => [:index, :create, :destroy]
  resources :analytics,   :only => [:index]
  resources :sessions,    :only => [:new, :create, :destroy]
  
  match 'activities/:id/clone'  => 'activities#clone',  :as => :clone_activity
  match '/reset_password'       => 'sessions#reset_password',    :as => :reset_password
  match '/email_reset_password'  => 'users#email_reset_password',    :as => :email_reset_password
  match '/edit_password'        => 'users#edit_password',   :as => :edit_password
  #match 'users/confirm'         => 'users#confirm',     :as => :confirm_user
  #match 'users/:id/timezone'    => 'users#timezone',    :as => :timezone_user
  
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  
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
  root :to => "activities#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
