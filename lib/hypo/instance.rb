require 'hypo/chainable'

module Hypo
  class Instance
    include Chainable

    attr_reader :name, :container

    def initialize(object, container, name)
      raise ContainerError, 'Registered object should have a name' if name.nil?

      @object = object
      @container = container
      @name = name
    end

    def instance
      @object
    end
  end
end
