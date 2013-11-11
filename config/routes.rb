Leadpump::Application.routes.draw do

  match '/appointments/filter_app' => 'appointments#filter_app'
  resources :discounts_on_periods
  resources :appointments
  resources :discounts_on_locations
  resources :company
  resources :leads 
  resources :subscriptions
  resources :plans

  devise_for :users, :controllers => {:registrations => "registrations"}

  root to: "home#index"

  
  
  match '/home/fillpopupcontent' => 'home#fillpopupcontent'
  match '/home/changestatus' => 'home#changestatus'
  match '/home/saveleadstatus' => 'home#saveleadstatus'
  match 'home/index' => 'home#index'
  match '/success' => 'home#success'
  match '/home/calculateAmount' => 'home#calculateAmount'
  match '/home/validateEmail' => 'home#validateEmail'
  #   member do
      
  #   end
  #   collection do
  #     get 'leadassign'      
  #     get 'changeleadstatus'
  #     get 'saveleadstatus'
  #     get 'filterbyname'
  #     get 'leadassigntouser'
  #   end
  # end
  match '/update/:id' => 'leads#update', :as => :update
  match '/leads/leadassign' => 'leads#leadassign'
  match '/leads/leadassigntouser' => 'leads#leadassigntouser'
  match '/leads/changeleadstatus' => 'leads#changeleadstatus'
  match '/leads/saveleadstatus' => 'leads#saveleadstatus'
  match '/leads/filterbyname' => 'leads#filterbyname'
  match '/leads/leadsearchfilter' => 'leads#leadsearchfilter'
  match '/leads/getemails' => 'leads#getemails'


  match 'appointment/new' => 'appointments#new'
  match 'appointment/create' => 'appointments#create'
  match 'appointment/index' => 'appointments#index'

  resources :leads 

  root to: "home#index"
  resources :subscriptions
  resources :plans

  match 'home/index' => 'home#index'
  match '/success' => 'home#success'
  
  match '/test' => 'home#test'
  match '/home/calculateAmount' => 'home#calculateAmount'
  match '/home/validateEmail' => 'home#validateEmail'

  match '/company/getemails' => 'company#getemails'
  match '/company/usersearchfilter' => 'company#usersearchfilter'
  match '/company/changeuserstatus' => 'company#changeuserstatus'
  match '/company/index' => 'company#index'
  match '/company/new' => 'company#new'
  match '/company/show' => 'company#show'
  match '/company/create' => 'company#create'
  match '/edit/:id' => 'company#edit', :as => :edit
  match '/update/:id' => 'company#update', :as => :update
  match '/delete/:id' => 'company#delete', :as => :delete

  


  # match "/stripe_events", :to => "events#stripe_events", :as => :stripe_events, :via => :post

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
