module Hypo
  module ScopeFriendly
    def bind_to(scope)
      if scope.is_a? Symbol
        @scope_name = scope
      else
        @scope = scope
        @scope.instance_variable_set('@instances'.freeze, Hash.new)
      end

      self
    end

    def scope
      if @scope.nil? && @scope_name.nil?
        raise ContainerError, "Component \"#{@name}\" must be bound to a scope" \
            " according to Hypo::Lifetime::Scope lifetime strategy"
      end

      @scope || @container.resolve(@scope_name)
    end

    alias bound_to bind_to
  end
end