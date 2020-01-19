require 'hypo/container_error'
require 'hypo/missing_component_error'
require 'hypo/component'
require 'hypo/instance'
require 'hypo/lifetime/transient'
require 'hypo/lifetime/singleton'
require 'hypo/lifetime/scope'

module Hypo
  class Container
    attr_reader :lifetimes, :components

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
      if %w(attrs attributes).include? name
        raise ContainerError, "Name \"#{name}\" is reserved by Hypo container please use another variant."
      end

      @mutex.synchronize do
        instance = Instance.new(item, self, name)
        @components[name] = instance
      end

      @components[name]
    end

    def resolve(name, attrs = nil)
      if [:attrs, :attributes].include? name
      else
        unless @components.key?(name)
          raise MissingComponentError.new(name)
        end

        @components[name].instance(attrs)
      end
    end

    def add_lifetime(lifetime, name)
      @lifetimes[name] = lifetime

      self
    end

    def show(component_name)
      @components[component_name]
    end
  end
end
