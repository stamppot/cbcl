require_dependency 'application'

# All controllers in ActiveRBAC extend this controller.
#
# It is only responsible for loading the model classes and the RbacHelper
# at the moment.
class ActiveRbac::ComponentController < ApplicationController
  require_dependency "user"
  require_dependency "role"
  require_dependency "group"
  require_dependency "static_permission" # was: model
  helper :rbac
end