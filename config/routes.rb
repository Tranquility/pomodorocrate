Ketchup::Application.routes.draw do

  get "widgets/active_pomodoro"
  get "widgets/activity_status"
  get "widgets/recent_activities"
  get "widgets/upcoming_activities"
  get "widgets/overdue_activities"
  get "widgets/upcoming_appointments"

  get "comments/index"
  get "comments/create"
  get "comments/destroy"

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  match 'pomodoros/update_current_form'   => 'pomodoros#update_current_form'
  match 'pomodoros/get_time_from_server'  => 'pomodoros#get_time_from_server'
  match 'pomodoros/current'               => 'pomodoros#current'
  
  match 'breaks/current'                  => 'breaks#current'
  
  match 'todotodays/save_sort'            => 'todotodays#save_sort'

  resources :activities, :projects
  resources :pomodoros,         :except => [:edit, :new, :show]
  resources :users,             :except => [:index, :show, :destroy]
  resources :breaks,            :only => [:create, :update]
  resources :todotodays,        :only => [:index, :create, :destroy]
  resources :analytics,         :only => [:index]
  resources :sessions,          :only => [:new, :create, :destroy]
  resources :contact_requests,  :only => [:new, :create, :show]
  resources :interruptions,     :only => [:create]
  resources :comments,          :only => [:index, :create, :destroy]
  resources :settings,          :only => [:edit, :update]
  
  match 'activities/:id/clone'    => 'activities#clone',                :as => :clone_activity
  match '/reset_password'         => 'sessions#reset_password',         :as => :reset_password
  
  match '/email_reset_password'   => 'users#email_reset_password',      :as => :email_reset_password
  match '/edit_password'          => 'users#edit_password',             :as => :edit_password
  
  match 'users/:id/settings'      => 'users#settings',                  :as => :edit_user_settings
  
  #match 'users/confirm'         => 'users#confirm',     :as => :confirm_user
  #match 'users/:id/timezone'    => 'users#timezone',    :as => :timezone_user
  
  match '/signup',  :to => 'users#new', :as => :signup
  match '/signin',  :to => 'sessions#new', :as => :signin
  match '/signout', :to => 'sessions#destroy', :as => :signout
  
  match '/help', :to => 'help#index'
  
  get "tags/user_tags"
  get "tags/activity_tags"
  get "tags/project_tags"
  
  #match '/contact', :to => 'contact#index'
  #match '/contacts', :to => 'contact#index', :as => :contacts
  resources :contacts
  
  # static pages
  resources :pages
  match '/home', :to => 'pages#home'
  
  # restful api
  # match '/analytics/render_complete_pomodoros/:start_date/:end_date', :to => 'analytics#render_complete_pomodoros'
  resources :apikeys, :only => [:create, :destroy]
  match '/apikeys', :to => 'apikeys#destroy'
  
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
  root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
