module Hypo
  module LifeCycle
    class Transient
      def instance(component)
        component.type.new(*component.dependencies)
      end
    end
  end
end
