module Hypo
  class Instance
    attr_reader :name

    def initialize(object, container, name)
      raise ContainerError, 'Registered object should have a name' if name.nil?

      @object = object
      @container = container
      @name = name
    end

    def instance
      @object
    end
  end
end
