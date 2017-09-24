module Hypo
  module Lifetime
    class Scope
      def initialize
        @instances = {}
      end

      def instance(component)
        scope = component.scope.object_id
        @instances[scope] = {} unless @instances.key? scope

        unless @instances[scope].key? component.name
          if component.respond_to? :type
            @instances[scope][component.name] = component.type.new(*component.dependencies)
          else
            @instances[scope][component.name] = component.object
          end
        end

        @instances[scope][component.name]
      end

      def purge(scope)
        @instances[scope.object_id].each_value do |instance|
          instance.finalize if instance.respond_to? :finalize
        end

        @instances.delete scope.object_id
      end
    end
  end
end
