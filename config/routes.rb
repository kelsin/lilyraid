ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  map.connect 'calendar/raids.ics', :controller => 'calendar', :action => 'raids'

  map.resources :lists

  map.resources :accounts, :member => { 'add_to_list' => :post }  do |accounts|
    accounts.resources :characters, :member => { 'roles' => :get }
  end

  map.resources :raids, :member => { 'finalize' => :post } do |raids|
    raids.resources :signups, :loots
    raids.resources :slots, :collection => { 'wait_list' => :put }
    raids.resources :locations
  end

  map.namespace :admin do |admin|
    admin.resources :characters
    admin.resources :accounts, :collection => { 'rename' => :post }
    admin.resources :templates
  end
  
  map.login('login',
            :controller => 'login',
            :action => 'index',
            :conditions => { :method => :get })
  map.logout('logout',
             :controller => 'login',
             :action => 'logout',
             :conditions => { :method => :get })
  map.login_post('login',
                 :controller => 'login',
                 :action => 'login',
                 :conditions => { :method => :post })
  
  map.root :controller => 'raids'

  map.connect 'roles/:id', :controller => 'characters', :action => 'roles'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
