module Hypo
  module LifeCycle
    class Singleton
      def initialize
        @instances = {}
      end

      def instance(component)
        unless @instances.key? component.name
          @instances[component.name] = component.type.new(*component.dependencies)
        end

        @instances[component.name]
      end
    end
  end
end
