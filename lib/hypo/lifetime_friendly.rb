module Hypo
  module LifetimeFriendly
    def use_lifetime(name)
      unless @container.lifetimes.key? name
        raise ContainerError, "Lifetime with name \"#{name}\" is not registered"
      end

      @lifetime = @container.lifetimes[name]
      @lifetime.preload(self) if @lifetime.respond_to? :preload

      self
    end

    alias using_lifetime use_lifetime
  end
end