module Hypo
  module Lifetime
    class Transient
      def instance(component, attrs = nil)
        if component.respond_to? :type
          dependencies = attrs ? [attrs].concat(component.dependencies) : component.dependencies
          component.type.new(*dependencies)
        else
          component.object
        end
      end
    end
  end
end
