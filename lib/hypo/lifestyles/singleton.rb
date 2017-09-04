module Hypo
  class Singleton
    def initialize(component)
      @component = component
    end

    def instance
      @instance = @component.type.new(*@component.dependencies) if @instance.nil?
      @instance
    end
  end
end
