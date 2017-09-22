module Hypo
  class Instance
    attr_reader :name, :container, :scope, :object

    def initialize(object, container, name)
      raise ContainerError, 'Registered object should have a name' if name.nil?

      @object = object
      @container = container
      @lifetime = container.lifetimes[:transient]
      @name = name
    end

    def instance
      @lifetime.instance(self)
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
