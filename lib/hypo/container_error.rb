module Hypo
  class ContainerError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
