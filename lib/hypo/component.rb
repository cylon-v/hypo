require 'hypo/lifetime/transient'

module Hypo
  class Component
    attr_reader :name, :type, :container, :lifetime, :scope

    def initialize(type, container, name = nil)
      @container = container
      @type = type
      @name = name || type.name.gsub(/(.)([A-Z](?=[a-z]))/, '\1_\2').delete('::').downcase.to_sym
      @lifetime = container.lifetimes[:transient]
      @dependency_names = @type.instance_method(:initialize).parameters.map {|p| p[1]}
    end

    def instance
      instance = @lifetime.instance(self)

      @dependency_names.each do |dependency|
        instance.instance_variable_set "@#{dependency}".to_sym, @container.resolve(dependency)
      end

      instance
    end

    def dependencies
      @dependency_names.map { |dependency| @container.resolve(dependency) }
    end

    def use_lifetime(lifetime)
      @lifetime = @container.lifetimes[lifetime]

      self
    end

    def bind_to(scope)
      if scope.is_a? Symbol
        @scope = @container.resolve(scope)
      else
        @scope = scope
      end

      self
    end

    alias using_lifetime use_lifetime
    alias bound_to bind_to
  end
end
