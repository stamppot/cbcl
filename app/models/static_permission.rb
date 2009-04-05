class StaticPermission < ActiveRecord::Base
  include ActiveRbacMixins::StaticPermissionMixins::Core

  # attr_reader :identifier
  # 
  # def initialize(identifier)
  #   @identifier = identifier.dup
  # end
end