module Permissionable
  class InvalidPermissionAssignment < StandardError
    def initialize(object)
      if object == 0
        super "Can not assign a permission the value 0" 
      elsif !object.is_a?(Fixnum)
        super "Can not assign permissions to values of type #{object.class.name} (only Fixnum allowed)"
      end
    end
  end
end
