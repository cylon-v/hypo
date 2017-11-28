require 'hypo/container_error'
require 'hypo/component'
require 'hypo/instance'
require 'hypo/lifetime/transient'
require 'hypo/lifetime/singleton'
require 'hypo/lifetime/scope'

module Hypo
  class Container
    attr_reader :lifetimes

    def initialize
      @components = {}
      @lifetimes = {}
      @mutex = Mutex.new

      add_lifetime(Lifetime::Transient.new, :transient)
      add_lifetime(Lifetime::Singleton.new, :singleton)
      add_lifetime(Lifetime::Scope.new, :scope)
      register_instance self, :container
    end

    def register(item, name = nil)
      unless item.is_a?(Class)
        raise ContainerError, 'Using method "register" you can register only a type. ' \
          'If you wanna register an instance please use method "register_instance".'
      end

      component = Component.new(item, self, name)

      @mutex.synchronize do
        @components[component.name] = component
      end

      @components[component.name]
    end

    def register_instance(item, name)
      @mutex.synchronize do
        instance = Instance.new(item, self, name)
        @components[name] = instance
      end

      @components[name]
    end

    def resolve(name)
      unless @components.key?(name)
        raise ContainerError, "Component with name \"#{name}\" is not registered"
      end

      @components[name].instance
    end

    def add_lifetime(lifetime, name)
      @lifetimes[name] = lifetime

      self
    end
  end
end
