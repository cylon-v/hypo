module Hypo
  module LifetimeFriendly
    def use_lifetime(name)
      unless @container.lifetimes.key? name
        raise ContainerError, "Lifetime with name \"#{name}\" is not registered"
      end

      @lifetime = @container.lifetimes[name]

      self
    end

    alias using_lifetime use_lifetime
  end
end