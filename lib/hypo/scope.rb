module Hypo
  module Scope
    attr_reader :instances

    def release
      @container.lifetimes[:scope].purge(self)
    end

    def purge
      @instances.each_value do |instance|
        instance.finalize if instance.respond_to? :finalize
      end

      @instances = Hash.new
    end
  end
end