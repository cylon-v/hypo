require 'hypo/life_cycle/transient'

module Hypo
  class Component
    attr_reader :name, :type, :container, :life_cycle

    def initialize(type, container, name = nil)
      @container = container
      @life_cycle = Transient.new(self)

      @type = type
      @name = name || type.name.gsub(/(.)([A-Z](?=[a-z]))/, '\1_\2').delete('::').downcase.to_sym
    end

    def instance
      @life_cycle.instance
    end

    def dependencies
      @type.instance_method(:initialize).parameters.map { |p| @container.resolve(p[1]) }
    end

    def use_life_cycle(life_cycle)
      @life_cycle = life_cycle.new(self)
    end

    alias using_life_cycle use_life_cycle
  end
end
