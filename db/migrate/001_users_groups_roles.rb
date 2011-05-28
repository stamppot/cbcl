class UsersGroupsRoles < ActiveRecord::Migration
  def self.up
    
    # groups
    create_table "groups", :force => true do |t|
      t.timestamp "created_at",                                  :null => false
      t.timestamp "updated_at",                                  :null => false
      t.string    "title",      :limit => 200, :default => "",   :null => false
      t.integer   "code"
      t.string    "type",       :limit => 16,  :default => "",   :null => false
      t.integer   "parent_id"
      t.integer   "center_id"
      t.boolean   "delta",                     :default => true, :null => false
    end
    add_index :groups, :center_id
    add_index :groups, :code
    add_index :groups, :delta
    add_index :groups, :type
    add_index :groups, :parent_id
    
    
    # users
    create_table "users", :force => true do |t|
      t.timestamp "created_at",                                                   :null => false
      t.timestamp "updated_at",                                                   :null => false
      t.timestamp "last_logged_in_at",                                            :null => false
      t.integer   "login_failure_count",                :default => 0,            :null => false
      t.string    "login",               :limit => 100, :default => "",           :null => false
      t.string    "name",                :limit => 100, :default => "",           :null => false
      t.string    "email",               :limit => 200, :default => "",           :null => false
      t.string    "password",            :limit => 128, :default => "",           :null => false
      t.string    "password_hash_type",  :limit => 10,  :default => "",           :null => false
      t.string    "password_salt",       :limit => 100, :default => "1234512345", :null => false
      t.integer   "state",                              :default => 1,            :null => false
      t.integer   "center_id"
      t.boolean   "login_user",                         :default => false
      t.integer   "delta"
    end
    add_index "users", ["center_id"], :name => "users_center_id_index"
    add_index "users", ["login"], :name => "users_login_index", :unique => true
    add_index "users", ["password"], :name => "users_password_index"
    
    # roles
    create_table "roles", :force => true do |t|
      t.string    "identifier", :limit => 50,  :default => "", :null => false
      t.timestamp "created_at",                                :null => false
      t.timestamp "updated_at",                                :null => false
      t.string    "title",      :limit => 100, :default => "", :null => false
      t.integer   "parent_id"
    end
    add_index "roles", ["parent_id"], :name => "roles_parent_id_index"
    
    # roles_users
    create_table "roles_users", :id => false, :force => true do |t|
      t.integer   "user_id",    :default => 0, :null => false
      t.integer   "role_id",    :default => 0, :null => false
      t.timestamp "created_at",                :null => false
    end
    add_index "roles_users", ["role_id"], :name => "role_id"
    add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true
    
    # groups_roles (not used)
    create_table "groups_roles", :id => false, :force => true do |t|
      t.integer   "group_id",   :default => 0, :null => false
      t.integer   "role_id",    :default => 0, :null => false
      t.timestamp "created_at",                :null => false
    end
    add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
    add_index "groups_roles", ["role_id"], :name => "role_id"
    
    # groups_users
    create_table "groups_users", :id => false, :force => true do |t|
      t.integer   "group_id",   :default => 0, :null => false
      t.integer   "user_id",    :default => 0, :null => false
      t.timestamp "created_at",                :null => false
    end
    add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
    add_index "groups_users", ["user_id"], :name => "user_id"
    
    
    
    # # read the SQL script
    # adapter = ActiveRecord::Base.configurations['development']['adapter']
    # 
    # schema_dir = Pathname.new(__FILE__).dirname.realpath.parent.to_s
    # filename = File.join(schema_dir, "cbcl_users_groups.sql") #"create.#{adapter}.sql")
    # 
    # raise "Could not find schema file #{filename}" unless File.exists?(filename)
    # 
    # fcontent = IO.read(filename)
    # 
    # # execute the SQL
    # puts "Executing SQL script #{filename}"
    # # execute SQL statements one by one since execute breaks with MySQL otherwise
    # fcontent.split(';').each do |statement|
    #   execute statement
    # end
    # puts "Complete"
  end

  def self.down # TODO: use this to insert sql data. Change so Drop/create is not used
    # Search all CREATE_TABLE statements and DROP all tables.
    # adapter = ActiveRecord::Base.configurations['development']['adapter']
    # 
    # schema_dir = Pathname.new(__FILE__).dirname.realpath.parent.to_s
    # filename = File.join(schema_dir, "cbcl_users_groups.sql") #"create.#{adapter}.sql")
    # 
    # raise "Could not find schema file #{filename}" unless File.exists?(filename)
    # 
    # fcontent = IO.read(filename)
    # 
    # tables = fcontent.scan %r{DROP TABLE IF EXISTS (\S*)}
    # tables.each { |t| t.first.gsub!(";", "")}
    # 
    # tables.each do |table_name|
    #   puts "DROPPING TABLE: #{table_name}"
    #   drop_table table_name
    # end
  end

end
