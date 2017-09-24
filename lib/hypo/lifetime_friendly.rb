module Hypo
  module LifetimeFriendly
    def use_lifetime(lifetime)
      @lifetime = @container.lifetimes[lifetime]

      self
    end

    alias using_lifetime use_lifetime
  end
end