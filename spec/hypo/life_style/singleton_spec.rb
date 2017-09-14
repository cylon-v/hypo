require 'spec_helper'
require 'hypo/component'
require 'hypo/life_cycle/singleton'
require 'stubs/test_type'

RSpec.describe Hypo::Singleton do
  describe 'instance' do
    context 'simple case' do
      before :all do
        container = Hypo::Container.new
        component = Hypo::Component.new(TestType, container)
        @life_cycle = Hypo::Singleton.new(component)
      end

      it 'returns component instance' do
        expect(@life_cycle.instance).to be_a TestType
      end

      context 'called twice' do
        it 'every time returns exactly the same instance' do
          instance1 = @life_cycle.instance
          instance2 = @life_cycle.instance

          expect(instance1).to equal instance2
        end
      end
    end

    context 'when a dependency has shorter life cycle' do
      it 'every new cycle of dependency returns its new instance' do
        container = Hypo::Container.new

        class TransientDependency
        end

        class SingletonComponent
          attr_reader :transient_dependency

          def initialize(transient_dependency)
            @transient_dependency = transient_dependency
          end
        end

        container.register(TransientDependency).using_life_cycle(Hypo::Transient)
        singleton_component = container.register(SingletonComponent).using_life_cycle(Hypo::Singleton)

        instance1 = singleton_component.instance.transient_dependency
        instance2 = singleton_component.instance.transient_dependency

        expect(instance1).not_to equal instance2
      end
    end
  end
end