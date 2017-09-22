module Hypo
  module Lifetime
    class Transient
      def instance(component)
        if component.respond_to? :type
          component.type.new(*component.dependencies)
        else
          component.object
        end
      end
    end
  end
end
