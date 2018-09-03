module Hypo
  module Lifetime
    class Scope
      def instance(component, attrs = nil)
        instances = component.scope.instances

        unless instances.key? component.name
          if component.respond_to? :type
            dependencies = attrs ? [attrs].concat(component.dependencies) : component.dependencies
            instances[component.name] = component.type.new(*dependencies)
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
