module Hypo
  module Lifetime
    class Singleton
      def initialize
        @instances = Hash.new
        @mutex = Mutex.new
      end

      def instance(component)
        @mutex.synchronize do
          unless @instances.key? component.name
            instance = component.respond_to?(:type) ? component.type.new(*component.dependencies) : component.object
            @instances[component.name] = instance
          end
        end

        @instances[component.name]
      end
    end
  end
end
