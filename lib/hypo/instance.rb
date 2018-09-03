require 'hypo/scope_friendly'
require 'hypo/lifetime_friendly'

module Hypo
  class Instance
    include ScopeFriendly
    include LifetimeFriendly

    attr_reader :name, :container, :object

    def initialize(object, container, name)
      raise ContainerError, 'Registered object should have a name' if name.nil?

      @object = object
      @container = container
      @lifetime = container.lifetimes[:transient]
      @name = name
    end

    def instance(attrs = nil)
      @lifetime.instance(self)
    end
  end
end
