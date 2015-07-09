require 'pry'
class Dummy
  include Permissionable

  permissions run: 1,
              walk: 2,
              sit: 3,
              play: 4,
              eat: 5

  def persisted?
    true
  end

  def initialize(attributes={})
    attributes.each do |attribute,value|
      setter_method = "#{attribute}=".to_sym
      self.send(setter_method, value)
    end
  end

end
