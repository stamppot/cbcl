class Role < ActiveRecord::Base
  include ActiveRbacMixins::RoleMixins::Core
  
  has_many :survey_answers
  
  def self.get(*roles)
    roles = roles.shift if roles.first.is_a?(Array)
    result = self.get_all(roles)
    return result.first if result.is_a?(Array) && result.size == 1
    result
  end

  def self.get_ids(*roles)
    result = self.get(roles)
    if result.is_a? Role
      result.id
    else
      result.map {|r| r.id}
    end
  end
  
  def self.get_all(roles)
    result = []
    roles = roles.shift if roles.first.is_a?(Array)
    roles.each_with_index do |r,i|
      if "production" == RAILS_ENV
        result << Rails.cache.fetch("role_#{r}") { Role.find_by_title(r.to_s) }
      else
        result << Role.find_by_title(r.to_s)
      end
    end
    return result.compact
  end
    
  # def has_static_permission?(identifier)
  #   @permissions.any? { |perm| perm.identifier == identifier }
  # end
  
  def Role.login_users
    r = Role.get(:login_bruger)
    return r.children
 end
 
end