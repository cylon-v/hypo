module Hypo
  class Component
    attr_reader :name, :type

    def initialize(type, container)
      @type = type
      @name = type.name.gsub(/(.)([A-Z](?=[a-z]))/,'\1_\2').downcase.to_sym
      @container = container
    end

    def instance
      dependencies = @type.instance_method(:initialize).parameters.map{|p| @container.resolve(p[1])}
      @instance = @type.new(*dependencies) if @instance.nil?

      @instance
    end
  end
end