module Hypo
  class Component
    attr_reader :name, :type

    def initialize(type)
      @type = type
      @name = type.name.gsub(/(.)([A-Z](?=[a-z]))/,'\1_\2').downcase.to_sym
    end

    def instance
      @instance = type.new if @instance.nil?

      @instance
    end
  end
end