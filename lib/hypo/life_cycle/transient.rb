module Hypo
  class Transient
    def initialize(component)
      @component = component
    end

    def instance
      @component.type.new(*@component.dependencies)
    end
  end
end
