module Hypo
  module Lifetime
    class Scope
      def instance(component)
        instances = component.scope.instances

        unless instances.key? component.name
          if component.respond_to? :type
            instances[component.name] = component.type.new(*component.dependencies)
          else
            instances[component.name] = component.object
          end
        end

        instances[component.name]
      end

      def purge(scope)
        scope.purge
      end
    end
  end
end
