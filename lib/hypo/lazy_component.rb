module Hypo
  class LazyComponent
    attr_reader :name, :type

    def initialize(type, container, name = nil)
      @type = type
      @name = name || type.name.gsub(/(.)([A-Z](?=[a-z]))/,'\1_\2').delete('::').downcase.to_sym
      @container = container
    end

    def instance
      dependencies = @type.instance_method(:initialize).parameters.map{|p| @container.resolve(p[1])}
      @instance = @type.new(*dependencies) if @instance.nil?

      @instance
    end
  end
end