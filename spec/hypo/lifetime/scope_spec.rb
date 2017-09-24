require 'spec_helper'
require 'hypo/component'
require 'hypo/lifetime/scope'
require 'stubs/test_type'
require 'stubs/test_scope'

RSpec.describe Hypo::Lifetime::Scope do
  before :all do
    @container = Hypo::Container.new
    @scope = TestScope.new
    @component = Hypo::Component.new(TestType, @container)
    @component.bind_to(@scope)
    @lifetime = Hypo::Lifetime::Scope.new
  end

  describe 'instance' do
    it 'returns component instance' do
      expect(@lifetime.instance(@component)).to be_a TestType
    end

    context 'called twice' do
      it 'every time returns exactly the same instance' do
        instance1 = @lifetime.instance(@component)
        instance2 = @lifetime.instance(@component)

        expect(instance1).to equal instance2
      end
    end

    context 'the same component from different scopes' do
      it 'returns different instance' do
        another_scope = TestScope.new
        component_clone = Hypo::Component.new(TestType, @container)
        component_clone.bind_to(another_scope)

        instance1 = @lifetime.instance(@component)
        instance2 = @lifetime.instance(component_clone)

        expect(instance1).not_to equal instance2
      end
    end

    context 'after purging' do
      it 'it returns new instance' do
        instance1 = @lifetime.instance(@component)
        @lifetime.purge(@scope)
        instance2 = @lifetime.instance(@component)

        expect(instance1).not_to equal instance2
      end
    end

    context 'when component scope is nil' do
      it 'raises error with specific message' do
        component_without_scope = Hypo::Component.new(TestType, @container)

        message = 'Component "test_type" must be bound to a scope' \
            ' according to Hypo::Lifetime::Scope lifetime strategy'

        expect {@lifetime.instance(component_without_scope)}
          .to raise_error(Hypo::ContainerError, message)
      end
    end

    context 'when trying to get instance of an instance first time' do
      it 'returns just registered instance of object' do
        obj = Object.new
        component = Hypo::Instance.new(obj, @container, :my_obj)
        component.bind_to(TestScope.new)
        instance = @lifetime.instance(component)

        expect(instance).to equal obj
      end
    end
  end
end