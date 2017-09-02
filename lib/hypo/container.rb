require 'hypo/container_error'
require 'hypo/component'

module Hypo
  class Container
    def initialize
      @components = {}
    end

    def register(type, name = nil)
      component = Component.new(type, self, name)
      if @components.key?(component.name)
        raise ContainerError, "Component of type \"#{component.type.to_s}\" has already been registered"
      end

      @components[component.name] = component
    end

    def resolve(name)
      unless @components.key?(name)
        raise ContainerError, "Component with name \"#{name}\" is not registered"
      end

      @components[name].instance
    end
  end
end
