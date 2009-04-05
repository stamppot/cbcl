ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => :view
  # Keep in mind you can assign values other than :controller and :action
  # ActiveRbac’s RegistrationController confirmation action needs
  # a special route
  # map.connect '/active_rbac/registration/confirm/:user/:token',
  #   :controller => 'active_rbac/registration',
  #   :action => :confirm
    
  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.

  # Index Route
  #map.connect '', :controller => 'survey', :action => :list

  # Install the default route as the lowest priority.
  map.resources :surveys
  map.resources :variables
  
  # map the admin stuff into '/admin/'
  map.connect '/user/:action/:id', :controller => 'active_rbac/user'
  map.connect '/admin/group/:action/:id', :controller => 'active_rbac/group'
  map.connect '/admin/role/:action/:id', :controller => 'active_rbac/role'
  map.connect '/admin/static_permission/:action/:id', :controller => 'active_rbac/static_permission'
  
  # map the login and registration controller somewhere prettier
  map.user_login 'login', :controller => 'login', :action => 'login'
  map.user_logout 'logout', :controller => 'login', :action => 'logout'
  map.connect '/login', :controller   => :login, :action => :login
  map.connect '/logout', :controller  => :login, :action => :logout
  map.connect '/shadow_login', :controller   => :login, :action => :shadow_login
  map.connect '/shadow_logout', :controller  => :login, :action => :shadow_logout

  # map.connect '/shadow_login', :controller   => :login, :action => :shadow_login, :id => :id
  # map.connect '/shadow_logout', :controller  => :login, :action => :shadow_logout
  map.shadow_login '/login/shadow_login', :controller => 'active_rbac/login', :action => 'shadow_login'
  map.shadow_logout '/login/shadow_logout', :controller => 'active_rbac/login', :action => 'shadow_logout'
    
  map.connect '/register/confirm/:user/:token',
    :controller => 'active_rbac/registration', :action => :confirm
  map.connect '/register/:action/:id', :controller => 'active_rbac/registration'
  map.connect '/registration/lostpassword', :controller => 'active_rbac/registration', :action => :lostpassword

  map.connect '/export_logins/:action/:id', :controller => 'export_logins', :action => :team, :id => :id
  
  # testing
  map.connect '/myaccount/:action/:id', :controller => 'active_rbac/my_account'
  
  # map.with_options(:controller => 'login') do |m|
  #   m.home '', :action => "/login"
  # end
  map.main '', :controller => 'main', :action => 'index'
  map.connect '', :controller => 'main', :action => 'index'
  
  # hide '/active rbac/*'
  #map.connect '/active_rbac/*foo', :controller => 'error'
  
  # Login Routes
  # map.connect 'login', :controller => 'login', :action => :login 
  # map.connect 'logout', :controller => 'login', :action => :logout
  #map.connect 'signup', :controller => 'login', :action => :signup

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => :wsdl

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
