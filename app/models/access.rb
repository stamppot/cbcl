class Access

  # attr_accessor :rights

  # def initialize
  #   @@rights = 
  
  def self.rights
    @@rights
  end

  def self.for_user(user)
    user && user.all_roles.map {|role| self.for(role.title.to_sym) }.foldl(:merge)
  end
  
  def self.for(role)
    result = {} # TODO: set global var with name of role. Speedup?
    @@rights.each do |perm, arr|
      if arr.include? role
        result[perm] = role
      end
    end
    result
  end
  
  def Access.instance
    return Access.new
  end

  def Access.roles(arg)
    return @@rights[arg]
  end

  # def roles(arg)
  #   return @rights[arg]
  # end


  @@access_config = {}

  @@rights = {
    :all_real_users             => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :login_users                => [:login_bruger, :parent, :teacher, :pedagogue, :youth],
    :group_show                 => [:superadmin],
    :group_all                  => [:superadmin, :admin], 
    :role_show                  => [:superadmin],
    :role_show_all              => [:superadmin, :admin],
    :shadow_login               => [:superadmin],
    
    :test_menu_show_menu        => [:superadmin],
    :user_new_leader            => [:superadmin, :admin],
    :user_new                   => [:superadmin, :admin, ::centeradmin, :teamadministrator],
    :user_new_in_center         => [::centeradmin, :teamadministrator],
    :user_edit_delete           => [:superadmin, :admin, ::centeradmin, :teamadministrator],
    :user_show                  => [::centeradmin, :teamadministrator, :behandler],
    :user_show_all              => [:superadmin],
    :user_show_admins           => [:admin],
    :user_show_teams            => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :user_view_status           => [:superadmin, ::centeradmin], 
    :centeradm_create_user      => [:behandler],  # not used

    :center_new                 => [:superadmin, :admin],
    :center_edit                => [:superadmin, :admin],
    :center_delete              => [:superadmin, :admin],
    :center_show                => [:superadmin, :admin, ::centeradmin],
    :center_show_admin          => [::centeradmin],
    :center_show_member         => [:behandler],
    :center_show_all            => [:superadmin, :admin],
    :center_show_teams          => [:superadmin, ::centeradmin, :behandler],
    :center_export_data         => [:superadmin, ::centeradmin],
    # :team_member_access         => [:behandler],
    # :team_access_all            => [::centeradmin],
    :team_show                  => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :team_show_all              => [:superadmin],  # shows all centers too
    # :team_show_none             => [:admin],
    # :team_show_admin            => [::centeradmin],
    :team_show_member           => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :team_new_edit_delete       => [:superadmin, ::centeradmin],
    # :subscription_new           => [:superadmin, :admin],
    :subscription_new_edit      => [:superadmin, :admin],
    :subscription_show_all      => [:superadmin, :admin],
    :subscription_show          => [:superadmin, :admin, ::centeradmin],
    :subscription_show_inactive => [:superadmin, :admin],
    :login_user_new_edit_delete => [:superadmin, :teamadministrator, :behandler],
    :journal_new_edit_delete    => [:superadmin, ::centeradmin, :teamadministrator, :behandler], # should not have superadmin
    :journal_show               => [:superadmin, :teamadministrator, :behandler],
    :journal_show_all           => [:superadmin],
    :journal_show_none          => [:admin],
    :journal_show_centeradm     => [:superadmin, ::centeradmin],
    :journal_show_member        => [:superadmin, :teamadministrator, :behandler],
    :survey_finish              => [:login_bruger],
    :survey_delete              => [:superadmin],
    :survey_new                 => [:superadmin],
    :survey_new_edit            => [:superadmin],
    :survey_edit_delete         => [],
    :survey_show_fast_input     => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :survey_show_all            => [:superadmin, :admin],
    :survey_show_subscribed     => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :survey_show_login          => [:login_bruger, :parent, :teacher, :pedagogue, :youth],
    :faq_edit                   => [:superadmin],
    :faq_admin                  => [:superadmin],
    :faq_show                   => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :faq_login                  => [:login_bruger, :parent, :teacher, :pedagogue, :youth],

    :score_edit                   => [:superadmin],
    :score_admin                  => [:superadmin],
    :score_show                   => [:superadmin, :admin],
    
    :score_export               => [:superadmin, :admin], 
    # admin layout
    # :layout_show_default_title => [:superadmin, :admin],
    # :layout_show_center_title  => [::centeradmin, :behandler, :login_bruger],
    :layout_show_login_info      => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_group_info      => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_menu            => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_user_menu       => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_users           => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_login_users     => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_group_menu      => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_teams_journals  => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :layout_show_survey_menu     => [:superadmin, :admin, ::centeradmin, :teamadministrator],
    :layout_show_only_surveys    => [:superadmin],
    :layout_show_subscriptions   => [:superadmin, :admin, ::centeradmin],
    :layout_show_scores          => [:superadmin, :admin],
    :layout_show_data_export     => [:superadmin, :admin, ::centeradmin, :teamadministrator],
    :layout_show_journal_menu    => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :show_column_actions         => [:superadmin, :admin],
    :layout_show_nationalities   => [:superadmin],
    :layout_show_center_search   => [:superadmin, :admin],
    :layout_show_settings_menu   => [:superadmin],

    # settings
    # :admin             => [:superadmin],           
    # :admin              => [:superadmin, :admin],
    # :all_users               => [:superadmin, :admin, ::centeradmin, :behandler ],
    :system_actions             => [:superadmin],
    :admin_actions              => [:superadmin, :admin],
    :user_actions               => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler ],
    :all_users                  => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler ],
    # Admin does not have access to normal functions in system
    :admin_roles                => [:admin],
    :center_users               => [::centeradmin, :teamadministrator, :behandler ],
    :users                      => [:superadmin, ::centeradmin, :teamadministrator, :behandler],
    :centeradm                  => [:superadmin, ::centeradmin],
    :teamadm                    => [:teamadministrator],
    :behandler                  => [:superadmin, :behandler],
    :login_user                 => [:login_bruger, :parent, :teacher, :pedagogue, :youth],
    :admin                      => [:superadmin, :admin],
    :superadmin                 => [:superadmin],
    :all_roles                  => [:superadmin, :admin, ::centeradmin, :teamadministrator, :behandler, :login_bruger, :parent, :teacher, :pedagogue, :youth ]# Role.all.map { |r| r.title }
  }
end
