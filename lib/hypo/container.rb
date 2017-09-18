require 'hypo/container_error'
require 'hypo/component'
require 'hypo/instance'
require 'hypo/life_cycle/transient'
require 'hypo/life_cycle/singleton'

module Hypo
  class Container
    attr_reader :life_cycles

    def initialize
      @components = {}
      @life_cycles = {}
      add_life_cycle(LifeCycle::Transient.new, :transient)
      add_life_cycle(LifeCycle::Singleton.new, :singleton)
      register_instance self, :container
    end

    def register(item, name = nil)
      unless item.is_a?(Class)
        raise ContainerError, 'Using method "register" you can register only a type. ' \
          'If you wanna register an instance please use method "register_instance".'
      end

      component = Component.new(item, self, name)

      if @components.key?(component.name)
        raise ContainerError, "Component \"#{component.name}\" has already been registered"
      end

      @components[component.name] = component
    end

    def register_instance(item, name)
      if item.is_a?(Class)
        raise ContainerError, 'Using method "register_instance" you can register only an instance. ' \
          'If you wanna register a type please use method "register".'
      end

      if @components.key?(name)
        raise ContainerError, "Component \"#{name}\" has already been registered"
      end

      instance = Instance.new(item, self, name)
      @components[name] = instance
    end

    def resolve(name)
      unless @components.key?(name)
        raise ContainerError, "Component with name \"#{name}\" is not registered"
      end

      @components[name].instance
    end

    def remove(name)
      @components.delete(name)
    end

    def add_life_cycle(life_cycle, name)
      @life_cycles[name] = life_cycle

      self
    end
  end
end
