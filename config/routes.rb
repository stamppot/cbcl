ActionController::Routing::Routes.draw do |map|
  map.resources :letters

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
  map.connect '/score_scales/order', :controller => 'score_scales', :action => 'order'

  # Install the default route as the lowest priority.
  map.resources :skemas
  map.resources :surveys
  map.resources :survey_answers
  map.resources :variables
  map.resources :subscriptions
  map.resources :centers
  map.resources :teams
  map.resources :journals
  map.resources :journal_entries, :only => [:show]
  map.resources :export_files
  map.resources :exports
  map.resources :faqs
  map.resources :faq_sections
  map.resources :users
  map.resources :roles
  map.resources :letters
  map.resources :login_users
  map.resources :nationalities
  map.resources :scores
  map.resources :score_scales
  map.resources :score_items
  map.resources :score_refs
  map.resources :score_reports
  map.resources :score_exports
  map.resources :survey_builders
  map.resources :journal_stats
  map.resources :code_books
  map.resources :reminders
  
  map.namespace(:active_rbac) do |active_rbac|
    active_rbac.resources :roles
  end
  
  # map the admin stuff into '/admin/'
  # map.connect '/user/:action/:id', :controller => 'active_rbac/user'
  map.connect '/admin/groups/:action/:id', :controller => 'active_rbac/groups'
  map.connect '/admin/roles/:action/:id', :controller => 'active_rbac/roles'
  map.connect '/admin/static_permission/:action/:id', :controller => 'active_rbac/static_permission'
  
  # map the login and registration controller somewhere prettier
  map.login '/login', :controller           => 'login', :action => 'index'
  map.logout '/logout', :controller         => 'login', :action => 'logout'
  map.connect '/login', :controller         => 'login', :action => 'index'
  map.connect '/logout', :controller        => 'login', :action => 'logout'
  map.connect '/shadow_login', :controller  => 'login', :action => 'shadow_login'
  map.connect '/shadow_logout', :controller => 'login', :action => 'shadow_logout'

  # map.connect '/shadow_login', :controller            => :login, :action => :shadow_login, :id => :id
  # map.connect '/shadow_logout', :controller           => :login, :action => :shadow_logout
  map.shadow_login '/login/shadow_login/:id', :controller   => 'login', :action => 'shadow_login'
  map.shadow_logout '/login/shadow_logout', :controller => 'login', :action => 'shadow_logout'

  # user
  map.change_password 'change_password/:id', :controller => 'user', :action => 'change_password'
  map.generate_password 'generate_password/:id', :controller => 'password', :action => 'new'
  
  # map.user_new_password     'new_password/:token',          :controller => 'user',              :action => 'new_password'
  # map.user                  'user/show/:id',                :controller => 'user',              :action => 'show'

  map.print_survey '/survey_prints/print/:id', :controller => 'survey_prints', :action => 'print'
  # map.print_survey_answer '/survey_answers/print/:id', :controller => 'survey_answers', :action => 'print'

  # center
  map.delete_center '/centers/delete/:id', :controller                         => 'centers', :action => 'delete'
  map.center_search 'centers/live_search/:id', :controller                     => 'centers', :action => 'live_search'
  map.subscriptions_new_period 'subscriptions/new_period/:id', :controller => 'centers', :action => 'new_subscription_period'
  map.subscriptions_undo_last_period 'subscriptions/undo_new_period/:id', :controller => 'centers', :action => 'undo_new_subscription_period'

  map.pay_subscriptions 'centers/pay_subscriptions/:id', :controller           => 'centers', :action => 'pay_subscriptions'
  map.undo_pay_subscriptions 'centers/undo_pay_subscriptions/:id', :controller => 'centers', :action => 'undo_pay_subscriptions'
  map.pay_periods 'centers/pay_periods/:id', :controller => 'centers',                       :action => 'pay_periods'
  map.merge_periods 'centers/merge_periods/:id', :controller => 'centers',                   :action => 'merge_periods'
  
  map.delete_team '/teams/delete/:id', :controller => 'teams', :action => 'delete'
  map.journals_for_center '/journals/center/:id', :controller => 'journals', :action => 'center'
  map.select_journals '/journals/select/:id', :controller => 'journals', :action => 'select'
  map.move_journals '/journals/move/:id', :controller => 'journals', :action => 'move'

  map.journal_search 'journals/live_search/:id', :controller   => 'journals', :action => 'live_search'
  map.new_journal 'journals/new/:id', :controller              => 'journals', :action => 'new'
  map.delete_journal '/journals/delete/:id', :controller       => 'journals', :action => 'delete'
  map.destroy_journal '/journals/destroy/:id', :controller     => 'journals', :action => 'destroy'
  map.journal_add_survey '/journals/add_survey/:id', :controller       => 'journals', :action => 'add_survey'
  map.journal_remove_survey '/journals/remove_survey/:id', :controller => 'journals', :action => 'remove_survey'

  # journal entries
  map.entry_show_answer 'journal_entries/show_answer/:id', :controller     => 'journal_entries', :action => 'show_answer'
  map.entry_remove 'journal_entries/remove/:id', :controller               => 'journal_entries', :action => 'remove', :only => :post
  map.entry_remove_answer 'journal_entries/remove_answer/:id', :controller => 'journal_entries', :action => 'remove_answer', :only => :post
  map.login_letter 'letters/show_login/:id', :controller                   => 'letters', :action => 'show_login'
  map.print_letters 'letters/show_logins/:id', :controller                 => 'letters', :action => 'show_logins'
  map.new_letter 'letters/new/:id', :controller                            => 'letters', :action => 'new'
  
  # map.destroy_login 'journal_entries/destroy_login/:id', :controller     => 'journal_entries', :action => 'destroy_login', :only => :post
  
  map.user_search 'users/live_search/:id', :controller   => 'users', :action => 'live_search'
  map.new_user 'users/new/:id', :controller => 'users', :action => 'new'
  map.delete_user '/users/delete/:id', :controller => 'users', :action => 'delete'
  map.new_team_in_center '/teams/new/:id', :controller => 'teams', :action => 'new'

  map.upgrade_browser 'upgrade', :controller => 'start', :action => 'upgrade'
  map.survey_start 'start', :controller => 'start', :action => 'start'
  map.survey_continue 'continue', :controller => 'start', :action => 'continue'
  map.survey_finish 'finish/:id', :controller => 'start', :action => 'finish'      # :id is login_user
  map.survey_show_fast 'surveys/show_fast/:id', :controller => 'surveys', :action => 'show_fast' # :id is entry
  map.survey_show_only 'surveys/show_only/:id', :controller => 'surveys', :action => 'show_only' # :id is entry
  map.survey_show_only_fast 'surveys/show_only_fast/:id', :controller => 'surveys', :action => 'show_only_fast' # :id is entry
  map.survey_save_draft 'survey_answers/save_draft/:id', :controller => 'survey_answers', :action => 'save_draft' # :id is entry
  map.survey_answer_create 'survey_answers/create/:id', :controller => 'survey_answers', :action => 'create'
  map.survey_answer_done 'survey_answers/done/:id', :controller => 'survey_answers', :action => 'done' # :id is entry
  
  # subscriptions
  map.new_subscription 'subscriptions/new/:id', :controller               => 'subscriptions', :action => 'new' # center id
  map.subscription_reset 'subscriptions/reset/:id', :controller           => 'subscriptions', :action => 'reset'
  map.subscription_reset_all 'subscriptions/reset_all/:id', :controller   => 'subscriptions', :action => 'reset_all'
  map.subscription_activate 'subscriptions/activate/:id', :controller     => 'subscriptions', :action => 'activate'
  map.subscription_deactivate 'subscriptions/deactivate/:id', :controller => 'subscriptions', :action => 'deactivate'
  map.set_subscription_not 'subscriptions/set_subscription_note/:id', :controller => 'subscriptions', :action => 'set_subscription_note'
  
  map.csv_download 'exports/download/:id', :controller => 'exports', :action => 'download'
  map.set_age_range 'exports/set_age_range/:id', :controller => 'exports', :action => 'set_age_range'
  map.export_filter 'exports/filter', :controller => 'exports', :action => 'filter'
  map.generating 'exports/generating_export/:id', :controller => 'exports', :action => 'generating_export'
  # map.csv_download 'exports/download', :controller => 'exports', :action => 'download'

  # map.csv_entry_status_download 'reminders/download/:id', :controller => 'reminders', :action => 'download'
  map.csv_entry_status_download 'reminders/download/:id.:format', :controller => 'reminders', :action => 'download', :format => 'csv'

  map.file_download 'export_files/download/:id', :controller => 'export_files', :action => 'download'
  map.export_logins 'export_logins/download/:id.:format', :controller => 'export_logins', :action => 'download', :format => 'csv'

  map.new_faq 'faqs/new/:id', :controller => 'faqs', :action => 'new'
  map.faq_answer 'faqs/answer/:id', :controller => 'faqs', :action => 'answer'
  map.faq_order_questions 'faq_sections/order_questions/:id', :controller => 'faq_sections', :action => 'order_questions'
  map.faq_done_order_questions 'faq_sections/done_order_questions/:id', :controller => 'faq_sections', :action => 'done_order_questions'
  map.faq_sort_questions 'faq_sections/sort_questions/:id', :controller => 'faq_sections', :action => 'sort_questions'
  map.faq_order 'faq_sections/order/:id', :controller => 'faq_sections', :action => 'order'
  map.faq_sort 'faq_sections/sort/:id', :controller => 'faq_sections', :action => 'sort'
  map.faq_done_order 'faq_sections/done_order/:id', :controller => 'faq_sections', :action => 'done_order'
  
  map.edit_score 'scores/edit/:id', :controller => 'scores', :action => 'edit'
  map.create_score_item 'score_items/create/:id', :controller => 'score_items', :action => 'create', :method => :post
  map.create_score_ref 'score_refs/create/:id', :controller => 'score_refs', :action => 'create', :method => :post

  map.scores_edit_survey 'score_scales/edit_survey', :controller => 'scores', :action => 'edit_survey'

  map.cancel_score_item 'score_items/cancel', :controller => 'score_items', :action => 'cancel'
  map.new_score_item 'score_items/new/:id', :controller => 'score_items', :action => 'new'
  map.new_score_ref 'score_refs/new/:id', :controller => 'score_refs', :action => 'new'
  map.cancel_score_ref 'score_refs/cancel', :controller => 'score_refs', :action => 'cancel'

  map.scores_order 'score_scales/order_scores', :controller => 'score_scales', :action => 'order_scores'
  map.scores_sort 'score_scales/sort_scores', :controller => 'score_scales', :action => 'sort_scores'
  map.scores_done_order 'score_scales/done_order_scores', :controller => 'score_scales', :action => 'done_order_scores'
  map.scales_order 'score_scales/order', :controller => 'score_scales', :action => 'order'
  map.scales_sort 'score_scales/sort', :controller => 'score_scales', :action => 'sort'
  map.scales_done_order 'score_scales/done_order', :controller => 'score_scales', :action => 'done_order'
  map.scale_surveys 'score_scales/scale_surveys', :controller => 'score_scales', :action => 'scale_surveys'

  map.create_score_report 'score_reports/create', :controller => 'score_reports', :action => 'create'
  
  map.lostpassword 'registration', :controller => 'active_rbac/registration', :action => :lostpassword
  # is this used?
  map.register 'registration', :controller => 'active_rbac/registration', :action => :registration


  # survey builder
  map.edit_survey_builder 'survey_builders/show_edit/:id', :controller => 'survey_builders', :action => 'show_edit'
  map.save_question_survey_builder 'survey_builders/save_question/:id', :controller => 'survey_builders', :action => 'save_question'
  map.add_question_survey_builder 'survey_builders/add_question/:id', :controller => 'survey_builders', :action => 'add_question'
  map.edit_survey_builder 'survey_builders/edit/:id', :controller => 'survey_builders', :action => 'edit'
  map.new_survey_builder 'survey_builders/new', :controller => 'survey_builders', :action => 'new'

  map.add_question_row 'survey_builders/add_question_row', :controller => 'survey_builders', :action => 'add_question_row'
  map.delete_question_row 'survey_builders/delete_question_row', :controller => 'survey_builders', :action => 'delete_question_row'
  map.add_question_column 'survey_builders/add_question_column', :controller => 'survey_builders', :action => 'add_question_column'
  map.delete_question_column 'survey_builders/delete_question_column', :controller => 'survey_builders', :action => 'delete_question_column'

  map.change_form 'survey_builders/change_form/:id', :controller => 'survey_builders', :action => 'change_form'
  map.change_back_form 'survey_builders/change_back_form/:id', :controller => 'survey_builders', :action => 'change_back_form'
  
  # map.destroy_survey_builder 'survey_builder/destroy', :controller => 'survey_builder', :action => 'destroy', :method => 'delete'

  map.connect '/register/confirm/:user/:token',
    :controller => 'active_rbac/registration', :action => :confirm
  # map.connect '/register/:action/:id', :controller => 'active_rbac/registration'
  # map.connect '/registration/lostpassword', :controller => 'active_rbac/registration', :action => :lostpassword

  # map.connect '/exports/:action/:id', :controller => 'exports', :action => :team, :id => :id
  
  # testing
  map.connect '/myaccount/:action/:id', :controller => 'active_rbac/my_account'

  map.connect '/export_logins/:action/:id.:format', :controller => 'export_logins', :action => 'download'
  # map.connect '/reminders/:action/:id.:format', :controller => 'reminders', :action => 'download'

  map.main '/main', :controller => 'main', :action => 'index'
  map.connect '', :controller => 'login', :action => 'index'
  
  # hide '/active rbac/*'
  #map.connect '/active_rbac/*foo', :controller => 'error'
  
  #map.connect 'signup', :controller => 'login', :action => :signup

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => :wsdl

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
  
  # error handling
  map.connect '*path', :controller => 'application', :action => 'rescue_404' unless ::ActionController::Base.consider_all_requests_local
end
