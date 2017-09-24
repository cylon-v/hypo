module Hypo
  module ScopeFriendly
    def bind_to(scope)
      if scope.is_a? Symbol
        @scope = @container.resolve(scope)
      else
        @scope = scope
      end

      self
    end

    alias bound_to bind_to
  end
end