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
    :all_real_users             => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :login_users                => [:login_bruger, :parent, :teacher, :pedagogue, :youth],
    :group_show                 => [:superadmin],
    :group_all                  => [:superadmin, :admin], 
    :role_show                  => [:superadmin],
    :role_show_all              => [:superadmin, :admin],
    :shadow_login               => [:superadmin],
    
    :test_menu_show_menu        => [:superadmin],
    :user_new_leader            => [:superadmin, :admin],
    :user_new                   => [:superadmin, :admin, :centeradministrator, :teamadministrator],
    :user_new_in_center         => [:centeradministrator, :teamadministrator],
    :user_edit_delete           => [:superadmin, :admin, :centeradministrator, :teamadministrator],
    :user_show                  => [:centeradministrator, :teamadministrator, :behandler],
    :user_show_all              => [:superadmin],
    :user_show_admins           => [:admin],
    :user_show_teams            => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :user_view_status           => [:superadmin, :centeradministrator], 
    :centeradm_create_user      => [:behandler],  # not used

    :center_new                 => [:superadmin, :admin],
    :center_edit                => [:superadmin, :admin],
    :center_delete              => [:superadmin, :admin],
    :center_show                => [:superadmin, :admin, :centeradministrator],
    :center_show_admin          => [:centeradministrator],
    :center_show_member         => [:behandler],
    :center_show_all            => [:superadmin, :admin],
    :center_show_teams          => [:superadmin, :centeradministrator, :behandler],
    :center_export_data         => [:superadmin, :centeradministrator],
    # :team_member_access         => [:behandler],
    # :team_access_all            => [:centeradministrator],
    :team_show                  => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :team_show_all              => [:superadmin],  # shows all centers too
    # :team_show_none             => [:admin],
    :team_show_admin            => [:centeradministrator],
    :team_show_member           => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :team_new_edit_delete       => [:superadmin, :centeradministrator],
    # :subscription_new           => [:superadmin, :admin],
    :subscription_new_edit      => [:superadmin, :admin],
    :subscription_show_all      => [:superadmin, :admin],
    :subscription_show          => [:superadmin, :admin, :centeradministrator],
    :subscription_show_inactive => [:superadmin, :admin],
    :login_user_new_edit_delete => [:superadmin, :teamadministrator, :behandler],
    :journal_new_edit_delete    => [:superadmin, :centeradministrator, :teamadministrator, :behandler], # should not have superadmin
    :journal_show               => [:superadmin, :teamadministrator, :behandler],
    :journal_show_all           => [:superadmin],
    :journal_show_none          => [:admin],
    :journal_show_centeradm     => [:superadmin, :centeradministrator],
    :journal_show_member        => [:superadmin, :teamadministrator, :behandler],
    :survey_finish              => [:login_bruger],
    :survey_delete              => [:superadmin],
    :survey_new                 => [:superadmin],
    :survey_new_edit            => [:superadmin],
    :survey_edit_delete         => [],
    :survey_show_fast_input     => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :survey_show_all            => [:superadmin, :admin],
    :survey_show_subscribed     => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :survey_show_login          => [:login_bruger, :parent, :teacher, :pedagogue, :youth],
    :faq_edit                   => [:superadmin],
    :faq_admin                  => [:superadmin],
    :faq_show                   => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :faq_login                  => [:login_bruger, :parent, :teacher, :pedagogue, :youth],

    :score_edit                   => [:superadmin],
    :score_admin                  => [:superadmin],
    :score_show                   => [:superadmin, :admin],
    
    # admin layout
    # :layout_show_default_title => [:superadmin, :admin],
    # :layout_show_center_title  => [:centeradministrator, :behandler, :login_bruger],
    :layout_show_login_info      => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_group_info      => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_menu            => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_user_menu       => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_users           => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_login_users     => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_group_menu      => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_teams_journals  => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :layout_show_survey_menu     => [:superadmin, :admin, :centeradministrator, :teamadministrator],
    :layout_show_only_surveys    => [:superadmin],
    :layout_show_subscriptions   => [:superadmin, :admin, :centeradministrator],
    :layout_show_scores          => [:superadmin, :admin],
    :layout_show_data_export     => [:superadmin, :admin, :centeradministrator, :teamadministrator],
    :layout_show_journal_menu    => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :show_column_actions         => [:superadmin, :admin],
    :layout_show_nationalities   => [:superadmin],
    :layout_show_center_search   => [:superadmin, :admin],
    :layout_show_settings_menu   => [:superadmin],

    # settings
    # :admin             => [:superadmin],           
    # :admin              => [:superadmin, :admin],
    # :all_users               => [:superadmin, :admin, :centeradministrator, :behandler ],
    :system_actions             => [:superadmin],
    :admin_actions              => [:superadmin, :admin],
    :user_actions               => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler ],
    :all_users                  => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler ],
    # Admin does not have access to normal functions in system
    :admin_roles                => [:admin],
    :center_users               => [:centeradministrator, :teamadministrator, :behandler ],
    :users                      => [:superadmin, :centeradministrator, :teamadministrator, :behandler],
    :centeradm                  => [:superadmin, :centeradministrator],
    :teamadm                    => [:teamadministrator],
    :behandler                  => [:superadmin, :behandler],
    :login_user                 => [:login_bruger, :parent, :teacher, :pedagogue, :youth],
    :admin                      => [:superadmin, :admin],
    :superadmin                 => [:superadmin],
    :all_roles                  => [:superadmin, :admin, :centeradministrator, :teamadministrator, :behandler, :login_bruger, :parent, :teacher, :pedagogue, :youth ]# Role.all.map { |r| r.title }
  }
end
