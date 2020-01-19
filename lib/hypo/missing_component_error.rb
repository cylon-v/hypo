module Hypo
  class MissingComponentError < ContainerError
    attr_reader :component_name

    def initialize(component_name)
      message = "Component with name \"#{component_name}\" is not registered"
      super(message)

      @component_name = component_name
    end
  end
end
