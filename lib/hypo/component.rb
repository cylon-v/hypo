require 'hypo/life_cycle/transient'
require 'hypo/chainable'
require 'hypo/extensions/string'

module Hypo
  class Component
    include Chainable

    attr_reader :name, :type, :container, :life_cycle

    def initialize(type, container, name = nil)
      @container = container
      @type = type
      @name = name || type.name.gsub(/(.)([A-Z](?=[a-z]))/, '\1_\2').delete('::').downcase.to_sym
      @life_cycle = container.life_cycles[:transient]
      @dependency_names = @type.instance_method(:initialize).parameters.map {|p| p[1]}
    end

    def instance
      instance = @life_cycle.instance(self)

      @dependency_names.each do |dependency|
        instance.instance_variable_set "@#{dependency}".to_sym, @container.resolve(dependency)
      end

      instance
    end

    def dependencies
      @dependency_names.map { |dependency| @container.resolve(dependency) }
    end

    def use_life_cycle(life_cycle)
      @life_cycle = container.life_cycles[life_cycle]

      self
    end

    alias using_life_cycle use_life_cycle
  end
end
