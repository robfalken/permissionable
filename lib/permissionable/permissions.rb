module Permissionable
  class Permissions
    def initialize(owner)
      @owner = owner
      if @owner.respond_to?(:read_attribute)
        @permissions_integer = @owner.read_attribute(:permissions_integer)
      else
        @permissions_integer = 0
      end
    end

    def to_i
      @permissions_integer
    end

    # Add new permissions
    # will safely ignore any permissions already granted
    # Usage:
    # MyModel.last.permissions.add(:write)
    # MyModel.last.permissions.add(:write, :read)
    def add(*permissions)
      permissions.flatten!
      control_definitions(permissions)
      permissions.each do |permission|
        new_permission = defined_permissions[permission]
        @permissions_integer += new_permission unless include?(permission)
      end
      sync_with_owner
    end
    alias_method :<<, :add

    # Remove existing permissions
    # will safely ignore any permissions not already granted
    # Usage:
    # resource.permissions.remove(:write)
    # resource.permissions.remove(:write, :read)
    def remove(*permissions)
      permissions.flatten!
      control_definitions(permissions)
      permissions.each do |permission|
        @permissions_integer -= defined_permissions[permission] if include?(permission)
      end
      sync_with_owner
    end

    # Check if resource has permission
    # Usage:
    # resource.permissions.include?(:write)
    # resource.permissions.include?(:write, :read)
    # @param *permissions [Array]
    # @return [TrueClass, FalseClass]
    def include?(*permissions)
      permissions.flatten!
      control_definitions(permissions)
      # Sum the corresponding int value of all 
      # permissions provided in the argument list
      asserted = permissions.inject(0){ |mem, permission| mem + defined_permissions[permission] }
      @permissions_integer & asserted == asserted
    end
    alias_method :[], :include?

    def clear!
      @permissions_integer = 0
      sync_with_owner
    end

    private 

    def control_definitions(permissions)
      permissions.each do |permission|
        raise "Permission #{permission} not defined" if defined_permissions[permission].nil?
      end
    end

    def sync_with_owner
      if @owner.respond_to?(:permissions_integer=)
        @owner.permissions_integer = @permissions_integer
      end
      if @owner.respond_to?(:update_column)
        if @owner.respond_to?(:persisted?) && @owner.persisted?
          @owner.update_column(:permissions_integer, @permissions_integer)
        end
      end
    end

    def defined_permissions
      @owner.class.get_permissions
    end

  end
end
