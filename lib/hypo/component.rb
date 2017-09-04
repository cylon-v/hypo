require 'hypo/lifestyles/transient'

module Hypo
  class Component
    attr_reader :name, :type, :container, :lifestyle

    def initialize(type, container, name = nil)
      @container = container
      @lifestyle = Transient.new(self)

      @type = type
      @name = name || type.name.gsub(/(.)([A-Z](?=[a-z]))/, '\1_\2').delete('::').downcase.to_sym
    end

    def instance
      @lifestyle.instance
    end

    def dependencies
      @type.instance_method(:initialize).parameters.map { |p| @container.resolve(p[1]) }
    end

    def use_lifestyle(lifestyle)
      @lifestyle = lifestyle.new(self)
    end

    alias using_lifestyle use_lifestyle
  end
end
