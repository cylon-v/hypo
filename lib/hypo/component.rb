require 'hypo/lifetime/transient'
require 'hypo/scope_friendly'
require 'hypo/lifetime_friendly'

module Hypo
  class Component
    include ScopeFriendly
    include LifetimeFriendly

    attr_reader :name, :type, :container, :lifetime, :scope

    def initialize(type, container, name = nil)
      @container = container
      @type = type
      @name = name || type.name.gsub(/(.)([A-Z](?=[a-z]))/, '\1_\2').delete('::').downcase.to_sym
      @lifetime = container.lifetimes[:transient]
      @dependency_names = @type.instance_method(:initialize).parameters.map {|p| p[1]}
    end

    def instance
      instance = @lifetime.instance(self)

      @dependency_names.each do |dependency|
        instance.instance_variable_set "@#{dependency}".to_sym, @container.resolve(dependency)
      end

      instance
    end

    def dependencies
      @dependency_names.map { |dependency| @container.resolve(dependency) }
    end
  end
end
