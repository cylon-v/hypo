require 'hypo/resolving_error'
require 'hypo/component'

module Hypo
  class Container
    def initialize
      @components = {}
    end

    def register(type)
      component = Component.new(type)
      @components[component.name] = component
    end

    def resolve(name)
      raise ResolvingError, name unless @components.key?(name)
      @components[name].instance
    end
  end
end
