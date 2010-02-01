class Role < ActiveRecord::Base
  include ActiveRbacMixins::RoleMixins::Core
  
  has_many :survey_answers
  
  # attr_reader :identifier
  # attr_reader :permissions

  # takes a symbol, finds by title
  # def self.get(*roles)
  #   roles = roles.shift if roles.first.is_a?(Array)
  #   list = roles.clone
  #   self.recursive_get_all([], list)
  # end
  
  def self.get(*roles)
    roles = roles.shift if roles.first.is_a?(Array)
    result = Role.get_all(roles)
    return result.first if result.is_a?(Array) && result.count == 1
    roles
  end
  
  # def self.get_ids(*roles)
  #   roles = roles.shift if roles.first.is_a?(Array)
  #   list = roles.clone
  #   (found = self.recursive_get_all([], list)).is_a?(Role) ? found.id : found.map {|r| r.id}
  # end

  def self.get_ids(*roles)
    result = self.get(roles)
    if result.is_a? Role
      result.id
    else
      result.map {|r| r.id}
    end
  end
  
  # recursive method
  # args: collection, role_titles
  # list of titles, 'admin', 'behandler'
  # array of titles, ['admin', 'behandler]
  # returns array for multiple results, Role for single result 
  # def self.recursive_get_all(col, roles)
  #   roles = roles.shift if roles.first.is_a?(Array)
  #   head, tail = roles.shift.to_s, roles
  #   if head && !head.empty?
  #     role_title = Rails.cache.fetch("role_#{head}") do
  #       Role.find_by_title(head)
  #     end
  #     col << role_title # Role.find_by_title(head)
  #     self.recursive_get_all(col, tail)
  #   else
  #     return (col.compact.size == 1 ? col.first : col.compact)
  #   end
  # end
  
  def self.get_all(roles)
    result = []
    roles = roles.shift if roles.first.is_a?(Array)
    roles.each do |r|
      role = r.to_s
      result << Rails.cache.fetch("role_#{role}") { Role.find_by_title(role) }
    end
    return result.compact
  end
    
  def has_static_permission?(identifier)
    @permissions.any? { |perm| perm.identifier == identifier }
  end
  
  def prettyname
    rolename = case self.title
    when "parent":    "forælder"
    when "youth":     "barn"
      when "teacher":   "lærer"
      when "pedagogue": "pædagog"
      when "other":     "andet"
      else self.title
      end
  end
  
  def Role.login_users
    r = Role.get(:login_bruger)
    return r.children
 end
 
 def Role.rolle
   {
     "forælder" => 1,
	   "pædagog"  => 2,
     "lærer"    => 3,
     "barn"     => 4,
	   "andet"    => 88
   }
 end
 
 def Role.roller
   {
     "forælder" => "parent",
     "lærer"    => "teacher",
	   "pædagog"  => "pedagogue",
     "barn"     => "youth",
	   "andet"    => "other"
   }
 end

end