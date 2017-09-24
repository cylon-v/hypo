module Hypo
  module Scope
    def release
      @container.lifetimes[:scope].purge(self)
    end
  end
end