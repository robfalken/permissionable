require "permissionable/version"
require "permissionable/permissions"

module Permissionable

  def permissions
    @permissions ||= Permissions.new(self)
  end

  # Class methods from here on
  module ClassMethods
    def permissions(permission_definitions)
      @permissions = {}
      permission_definitions.each do |permission,i|
        raise 'Can not assign 0' if i == 0
        raise "#{i} is not an integer" unless i.is_a?(Fixnum)
        if i == 1
          @permissions[permission] = 1 
        else
          @permissions[permission] = 2**(i-1)
        end
      end
    end

    def get_permissions
      @permissions || {}
    end
  end

  # Automatically extend class methods when module is included
  def self.included(base)
    base.extend(ClassMethods)
  end
end
