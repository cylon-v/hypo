module Hypo
  module Scope
    attr_reader :instances

    def release
      @container.lifetimes[:scope].purge(self)
    end

    def purge
      begin
        @instances.each_value do |instance|
          instance.finalize if instance.respond_to? :finalize
        end
      ensure
        @instances = Hash.new
      end
    end
  end
end