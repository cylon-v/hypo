require 'hypo/container_error'
require 'hypo/component'
require 'hypo/instance'
require 'hypo/extensions/string'

module Hypo
  class Container
    attr_reader :life_cycles

    def initialize
      @components = {}
      @life_cycles = {}
      add_life_cycle(LifeCycle::Transient, :transient)
      add_life_cycle(LifeCycle::Singleton, :singleton)
      register self, :container
    end

    def register(item, name = nil)
      type = item.is_a?(Class) ? Component : Instance
      component = type.new(item, self, name)

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

    def add_life_cycle(life_cycle, name)
      @life_cycles[name] = life_cycle.new

      self
    end
  end
end
