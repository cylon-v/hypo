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
      register self, :container
    end

    def register(item, name = nil)
      type = item.is_a?(Class) ? Component : Instance
      component = type.new(item, self, name)

      if @components.key?(component.name)
        raise ContainerError, "Component \"#{component.name}\" has already been registered"
      end

      @components[component.name] = component
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
