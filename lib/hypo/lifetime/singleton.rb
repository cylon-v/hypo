module Hypo
  module Lifetime
    class Singleton
      def initialize
        @instances = {}
      end

      def instance(component)
        unless @instances.key? component.name
          if component.respond_to? :type
            @instances[component.name] = component.type.new(*component.dependencies)
          else
            @instances[component.name] = component.object
          end
        end

        @instances[component.name]
      end
    end
  end
end
