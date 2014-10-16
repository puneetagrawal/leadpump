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
  resources :sale_prods

  match "/mallitemassign" => "onlinemall#mallitemassign"
  match '/mall/update/:id' => 'onlinemall#update', :as => :update
  match '/mallremove' => 'onlinemall#mallremove'
  match "/csvdownload" => "statss#csvdownload"      

  match "/opt_in_leads/viewContact" => "opt_in_leads#viewContact"
  match "/optlist" => "opt_in_leads#optlist"   
  match "/optsearchfilter" => "opt_in_leads#optsearchfilter"   
  match "/viplead/filter_opt" => "opt_in_leads#filter_opt"
  resources :opt_in_leads

  match "/createpic" => "picture#create"
  match "/createvippic" => "picture#createvippic"  
  match "/create_fb_logo" => "picture#create_fb_logo"
  resources :picture

  match "/statsearch" => "statss#statsearch"


  devise_for :users,:controllers => {:registrations => "registrations"}
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session    
  end
  match "/signup_user" => "home#signup_user"
  match "/create_new_user" => "home#create_new_user"
  match "/send_verification_mail" => "home#send_verification_mail"
  match "/confirmation" => "home#confirmation"
  match "/save_password" => "home#save_password"
  match "/save_address" => "home#save_address"
  match "/upload_company_logo" => "home#upload_company_logo"
  match "/upload_profile_pic" => "home#upload_profile_pic"
  match "/choose_plan" => "home#choose_plan"
  match "/skip_profile" => "home#skip_profile"
  match "/contact_form" => "home#contact_form"
  match "/intouch" => "home#intouch"
  match "home/guest_register_complete" => "home#guest_register_complete"

  root to: "home#signup_user"

  match "/fetchhotmailfriends" => "home#fetchhotmailfriends"
  match "/fetchfbfreinds" => "home#fetchfbfreinds"
  match "/acceptInvitation" => "vipleads#acceptInvitation"
  match "/invites" => "vipleads#invites"
  match "/fetchContacts" => "vipleads#fetchContacts"
  match "/showvipleads" => "vipleads#showvipleads"
  match "/searchvipleads" => "vipleads#searchvipleads"
  match "/vipleadsearchfilter" => "vipleads#vipleadsearchfilter"
  match "/sendIvitationToGmailFriend" => "vipleads#sendIvitationToGmailFriend"
  match "/sendIvitationToFbFriend" => "vipleads#sendIvitationToFbFriend"
  match "/mallitems/:id" => "vipleads#mallitems"
  match "/viewmallitem" => "vipleads#viewmallitem"
  match "/download" => "vipleads#download"
  match "/sendfbrewards" => "vipleads#sendfbrewards"

  resources :vipleads
  
  match '/dashboard' => 'home#index' , :as => :dashboard
  match '/home/fillpopupcontent' => 'home#fillpopupcontent'
  match '/home/changestatus' => 'home#changestatus'
  match '/home/saveleadstatus' => 'home#saveleadstatus'
  match '/success' => 'home#success'  
  match '/home/calculateAmount' => 'home#calculateAmount'
  match '/home/validateEmail' => 'home#validateEmail'
  match '/welcome' => 'home#welcome'
  match '/home/deleteRowByajax' => 'home#deleteRowByajax'
  match 'home/social_inviter' => 'referrals#new'
  match 'home/privacy' => 'home#privacy'
  match '/guest_register' => 'home#guest_register'
  match '/member_profile_basic' => 'home#member_profile_basic'
  match '/member_profile_advance' => 'home#member_profile_advance'
  match '/save_details' => 'home#save_details'
  match '/test' => 'home#test'
  match '/pass' => 'home#pass'
  match '/print_pass' => 'home#print_pass'
  match '/print_waiver_details' => 'home#print_waiver_details'
  match '/upgrade_plan' => 'home#upgrade_plan'
  match '/make_payment' => 'home#make_payment'
  match '/plan_upg_mail' => 'home#plan_upg_mail'
  match '/plan_cancel' => 'home#plan_cancel'
  match '/thanks' => 'home#thanks'
  match '/fetch_upgrade_plan' => 'home#fetch_upgrade_plan'
  match '/save_refs' => 'home#save_refs'
  
  match '/savereferral' => 'vipleads#savereferral'
  match '/admin/index' => 'admin#index'
  match '/users/sign_in/admin' => 'admin#index'
  match '/admin/plan' => 'admin#plan'
  match '/admin/payment' => 'admin#payment'
  match '/admin/user' => 'admin#user'
  match '/admin/remove_user' => 'admin#destroy'
  match '/admin/statistic' => 'admin#statistic' 
  match '/admin/user_rec' => 'admin#user_record'
  match '/admin/user_per_plan' => 'admin#user_per_plan'
  match '/admin/adminfilter' => 'admin#adminfilter'
  match '/admin/user_per_cmpy' => 'admin#user_per_cmpy'
  match '/filter_vip' => 'admin#filter_vip', :as => 'filter_vip'
  match '/filter_invite' => 'admin#filter_invite'
  match '/filter_payment' => 'admin#filter_payment', :as => 'filter_payment'
  match "/searchUserAc" => "admin#searchUserAc"
  match "/usersearchinadmin" => "admin#usersearchinadmin"
  match "/searchvipleadsadmin" => "admin#search_vip"
  match "/invitelist" => "admin#invitelist"
  match "/searchpaymentadmin" => "admin#search_payment"
  match "/vipleadsearchadminfilter" => "admin#vipleadsearchadminfilter"
  match "/paymentsearchfilter" => "admin#paymentsearchfilter"
  match "/invitesearchfilter" => "admin#invitesearchfilter"
  match "/editplanbyadmin" => "admin#editplanbyadmin"
  match "/invitestatsbyadmin" => "admin#invitestatsbyadmin"
  match "/setunlimited" => "admin#setunlimited"
  match "/updateplan" => "admin#updateplan"
  match "/change_user_status" => "admin#change_user_status", as: "change_user_status"
  match "/filter_user" => "admin#filter_user"
  match '/admin/saveplantype' => 'admin#saveplantype'
  #match '/admin/alterplantype' => 'admin#alterplantype'
  match '/admin/usercreatepopup' => 'admin#usercreatepopup'
  match '/admin/cmpycreatepopup' => 'admin#cmpycreatepopup'
  match '/createUser' => 'admin#createUser'
  match '/createCmpy' => 'admin#createCmpy'

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
  #match '/leads/changeleadstatus' => 'leads#changeleadstatus'
  match '/leads/saveleadstatus' => 'leads#saveleadstatus'
  match '/leads/leadsearchfilter' => 'leads#leadsearchfilter'
  match '/leads/getemails' => 'leads#getemails'
  match '/leads/socialInviter' => 'leads#socialInviter'

  match '/leads/test' => 'leads#index'
  match '/leads/createtask' => 'leads#createtask'
  match 'leads/saveappointment' => 'leads#saveappointment'
  match '/read_feed' => 'leads#read_feed'
  match '/add_notes' => 'leads#add_notes'
  match '/get_sorted_list' => 'leads#get_sorted_list'

  resources :leads do
    collection do 
      post 'save_lead_source'
    end
  end
  

  match 'appointment/new' => 'appointments#new'
  match '/calander' => 'appointments#calander'
  match '/get_cal_data' => 'appointments#get_cal_data'

  match 'appointment/create' => 'appointments#create'
  match 'appointment/index' => 'appointments#index'

  match '/viewusergauge' => 'company#viewusergauge'
  match '/previewsave' => 'company#previewsave'
  match '/preview/:id' => 'company#preview'
  match '/refland' => 'company#refland'
  match '/landpage' => 'company#landpage'
  match '/updatelanding/:id' => 'company#updatelanding', :as => :update
  match '/createlanding' => 'company#createlanding'
  match '/company/getemails' => 'company#getemails'
  match '/company/usersearchfilter' => 'company#usersearchfilter'
  match '/company/changeuserstatus' => 'company#changeuserstatus'
  match '/company/index' => 'company#index'
  match '/company/new' => 'company#new'
  match '/company/show' => 'company#show'
  match '/company/create' => 'company#create'
  match '/save_waiver_text' => 'company#save_waiver_text'
  match '/autoresponder' => 'company#autoresponder'
  match '/report' => 'company#report'
  match '/create_auto_responder' => 'company#create_auto_responder'
  match '/settings' => 'company#settings'
  match '/edit/:id' => 'company#edit', :as => :edit
  match '/company/update/:id' => 'company#update', :as => :update
  match '/delete/:id' => 'company#delete', :as => :delete
  match "/socialMessages" => "company#socialMessages"
  match "/social_message_page" => "company#social_message_page"
  match "/savetwmes" => "company#savetwmes"
  match "/savefbmes" => "company#savefbmes"
  match "/savegmmes" => "company#savegmmes" 
  match "/savevipsetings" => "company#savevipsetings"  
  match "/unsubscribe" => "company#unsubscribe"  
  match "/save_dusr_report" => "company#save_dusr_report"
  match "/auto_responder_subscribe" => "company#auto_responder_subscribe"
  match "/acc_setting_address" => "company#acc_setting_address"
  match "/save_acc_settings" => "company#save_acc_settings"
  match "/save_external_lead" => "company#save_external_lead", :as => :json
  match "/create_code_image" => "company#create_code_image"
  match "/home/change_locale" => "home#change_locale"

  match "/testsendgrid" => "home#testsendgrid"
  match "/trackEmail" => "vipleads#trackEmail"
  match "/storepassinsession" => "home#storepassinsession"
  
  match "/sendmail" => "home#sendmail"
  match "/send_invitation_social" => "home#send_invitation_social"
  match "/contacts/:provider/callback" => "vipleads#new"
  # match "/callback" => "home#contacts_callback"
  match "/contacts/failure" => "home#failure"

  match "/sale_prods/addnewprodrow" => "sale_prods#addnewprodrow"
  match "/sale_prods/showproduction" => "sale_prods#showproduction"
  match "/sale_prods/showreport" => "sale_prods#showreport"

  #match '/auth/:provider/callback' => 'vipleads#new'


  # match '/insert_prospect' => 'vipleads#insert_prospect'


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
  match 'home/terms' => 'home#terms'
end
