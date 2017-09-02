module Hypo
  class SimpleComponent
    attr_reader :name

    def initialize(object, container, name)
      raise ContainerError, 'Registered object should have a name' if name.nil?

      @object = object
      @name = name
      @container = container
    end

    def instance
      @object
    end
  end
end
