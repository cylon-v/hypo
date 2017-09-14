module Hypo
  module Chainable
    def register(item, name = nil)
      @container.register(item, name)
    end
  end
end