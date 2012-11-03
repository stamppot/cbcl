# encoding: utf-8
# The Group class represents a group record in the database and thus a group
# in the ActiveRbac model. Groups are arranged in trees and have a title.
# Groups have an arbitrary number of roles and users assigned to them. Child
# groups inherit all roles from their parents.
#
# The Group ActiveRecord class mixes in the "ActiveRbacMixins::GroupMixin" module.
# This module contains the actual implementation. It is kept there so
# you can easily provide your own model files without having to all lines
# from the engine's directory

# TODO: move needed functionality (primarily validation) from GroupMixin to here
# A group then has no roles anymore.
# 
class Group < ActiveRecord::Base
  include ActiveRbacMixins::GroupMixins::Core

   named_scope :direct_groups, lambda { |user| { :joins => "INNER JOIN `groups_users` ON `groups`.id = `groups_users`.group_id",
    :conditions => ["groups_users.user_id = ?", user.is_a?(User) ? user.id : user] } }

  named_scope :all_parents, lambda { |parent| { :conditions => parent.is_a?(Array) ? ["parent_id IN (?)", parent] : ["parent_id = ?", parent] } }
  named_scope :center_and_teams, :conditions => ['type != ?', "Journal"]
  named_scope :in_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  named_scope :and_parent, :include => [:parent]
  
  has_many :letters
  
  def self.this_or_parent(id)
    Group.find(:all, :conditions => [ 'id = ? OR parent_id = ?', id, id]).delete_if { |group| group.instance_of? Journal }
  end

  # returns Team or Center for id, or if not exists, all teams and centers of user
  def self.get_teams_or_centers(id, user)
    group = Group.and_parent.find_by_id(id)
    (group && !group.is_a?(Journal)) && [group] || user.center_and_teams
  end

  def get_title
    title # .force_encoding("UTF-8")
  end
  
  # all ascendants/parents
  def ascendants
    groups = []
    parent = self.parent
    while (!parent.nil?)
      groups << parent
      parent = parent.parent
    end
    groups
  end
  
  def group_code
    if self.is_a?(Team)
      self.team_code
    elsif self.is_a?(Center)
      "#{self.code}-000"
    else
      qualified_code
    end
  end
  
  def group_name_abbr
    group_name = title.split.map {|w| w.first }.join.downcase.slice(0,4)
  end
  
  def login_prefix
    group_name = title.split.map {|w| w.first }.join.downcase.slice(0,4)
    num = LoginUser.count(:conditions => ['center_id = ? and login LIKE ?', parent.nil? && id || parent.id, group_name + "%"]) + 1
    login_name = "#{group_name}-#{num}"
    while(LoginUser.find_by_login(login_name)) do
      num += 1
      login_name = "#{group_name}-#{num}"
    end
    login_name.gsub("Ø", "o").gsub("Æ", "ae").gsub("Å", "a")
  end

  protected

    # We want to validate a group's title pretty thoroughly.
    # validates_uniqueness_of :title, 
    #                         :message => 'er navnet på en allerede eksisterende gruppe.'
    
    
    #  DANISH_CHARS = "\u00c0-\u00d6\u00d8-\u00f6\u00f8"
    validates_format_of     :title, # \00c0-\00d6\00d8-\00f6\u00f8
                            :with => %r{^[\(w|Æ|Ø|Å|æ|ø|å|,|\w) \$\^\-\.#\*\+&'"]*$},
                            :message => 'må ikke indeholde ugyldige tegn.'
    validates_length_of     :title, 
                            :in => 2..100, :allow_nil => true,
                            :too_long => 'skal have mindre end 100 bogstaver.', 
                            :too_short => 'skal have mere end to bogstaver.',
                            :allow_nil => false,
                            :if => Proc.new { |group| group.is_a?(Team) or group.is_a?(Center) }
    # validates_presence_of   :parent,
    #                         :message => ': overordnet gruppe skal vælges',
    #                         :if => Proc.new { |group| group.class.to_s != "Center" }
                            
end
