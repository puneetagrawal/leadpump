Leadpump::Application.routes.draw do

  match '/appointments/filter_app' => 'appointments#filter_app'
  match '/tweet/ref' => 'tweet_referrals#new'
  resources :discounts_on_periods
  resources :appointments
  resources :discounts_on_locations
  resources :company
  resources :subscriptions
  resources :plans
  resources :referrals
  resources :tweet_referrals
  resources :statss
  resources :onlinemall

  match "/mallitemassign" => "onlinemall#mallitemassign"
  match '/mall/update/:id' => 'onlinemall#update', :as => :update
  match '/mallremove' => 'onlinemall#mallremove'
  match "/csvdownload" => "statss#csvdownload"      

  match "/opt_in_leads/viewContact" => "opt_in_leads#viewContact"    
  resources :opt_in_leads

  match "/createpic" => "picture#create"  
  resources :picture

  match "/statsearch" => "statss#statsearch"


  devise_for :users, :controllers => {:registrations => "registrations"}

  root to: "home#index"

  match "/fetchfbfreinds" => "home#fetchfbfreinds"
  match "/acceptInvitation" => "vipleads#acceptInvitation"
  match "/invites" => "vipleads#invites"
  match "/fetchContacts" => "vipleads#fetchContacts"
  match "/showvipleads" => "vipleads#showvipleads"
  match "/searchvipleads" => "vipleads#searchvipleads"
  match "/vipleadsearchfilter" => "vipleads#vipleadsearchfilter"
  match "/viplead/filter_rec" => "vipleads#filter_rec"
  match "/sendIvitationToGmailFriend" => "vipleads#sendIvitationToGmailFriend"
  match "/sendIvitationToFbFriend" => "vipleads#sendIvitationToFbFriend"
  match "/mallitems" => "vipleads#mallitems"
  match "/viewmallitem" => "vipleads#viewmallitem"
  match "/download" => "vipleads#download"

  resources :vipleads
  
  match 'home/index' => 'home#index'
  match '/home/fillpopupcontent' => 'home#fillpopupcontent'
  match '/home/changestatus' => 'home#changestatus'
  match '/home/saveleadstatus' => 'home#saveleadstatus'
  match '/success' => 'home#success'  
  match '/home/calculateAmount' => 'home#calculateAmount'
  match '/home/validateEmail' => 'home#validateEmail'
  match '/welcome' => 'home#welcome'
  match '/home/deleteRowByajax' => 'home#deleteRowByajax'

  match 'home/social_inviter' => 'referrals#new'
  match 'home/terms' => 'home#terms'
  match '/test' => 'home#test'



  match '/savereferral' => 'vipleads#savereferral'
  match '/admin/index' => 'admin#index'
  match '/admin/plan' => 'admin#plan'
  match '/admin/payment' => 'admin#payment'
  match '/admin/user' => 'admin#user'
  match '/admin/remove_user' => 'admin#destroy'
  match '/admin/statistic' => 'admin#statistic' 
  match '/admin/user_rec' => 'admin#user_record'
  match '/admin/user_per_plan' => 'admin#user_per_plan'
  match '/filter_vip' => 'admin#filter_vip', :as => 'filter_vip'
  match '/filter_payment' => 'admin#filter_payment', :as => 'filter_payment'
  match "/searchUserAc" => "admin#searchUserAc"
  match "/usersearchinadmin" => "admin#usersearchinadmin"
  match "/searchvipleadsadmin" => "admin#search_vip"
  match "/searchpaymentadmin" => "admin#search_payment"
  match "/vipleadsearchadminfilter" => "admin#vipleadsearchadminfilter"
  match "/paymentsearchfilter" => "admin#paymentsearchfilter"
  match "/editplanbyadmin" => "admin#editplanbyadmin"
  match "/setunlimited" => "admin#setunlimited"
  match "/updateplan" => "admin#updateplan"

   namespace :admin do
     root :to => "admin#index"
     resources :users, :subscriptions, :plans, :payments, :vipleads
  end

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
  match '/leads/socialInviter' => 'leads#socialInviter'

  match '/leads/test' => 'leads#index'
  match '/leads/createtask' => 'leads#createtask'
  match 'leads/saveappointment' => 'leads#saveappointment'

  resources :leads 
  

  match 'appointment/new' => 'appointments#new'
  match 'appointment/create' => 'appointments#create'
  match 'appointment/index' => 'appointments#index'
  
  
  match '/landpage' => 'company#landpage'
  match '/updatelanding' => 'company#updatelanding'
  match '/createlanding' => 'company#createlanding'
  match '/company/getemails' => 'company#getemails'
  match '/company/usersearchfilter' => 'company#usersearchfilter'
  match '/company/changeuserstatus' => 'company#changeuserstatus'
  match '/company/index' => 'company#index'
  match '/company/new' => 'company#new'
  match '/company/show' => 'company#show'
  match '/company/create' => 'company#create'
  match '/settings' => 'company#settings'
  match '/edit/:id' => 'company#edit', :as => :edit
  match '/company/update/:id' => 'company#update', :as => :update
  match '/delete/:id' => 'company#delete', :as => :delete
  match "/socialMessages" => "company#socialMessages"
  match "/savetwmes" => "company#savetwmes"
  match "/savefbmes" => "company#savefbmes"
  match "/savegmmes" => "company#savegmmes"
  match "/testsendgrid" => "home#testsendgrid"
  match "/trackEmail" => "vipleads#trackEmail"
  match "/sendmail" => "home#sendmail"



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
