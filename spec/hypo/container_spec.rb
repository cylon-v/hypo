require 'spec_helper'
require 'stubs/test_type'
require 'hypo/container_error'

RSpec.describe Hypo::Container do
  describe 'register' do
    context 'when name is specified' do
      before :each do
        @container = Hypo::Container.new
        @container.register(TestType)
      end

      it 'registers component and can resolve it by type name' do
        instance = @container.resolve(:test_type)
        expect(instance).to be_a TestType
      end
    end

    context 'when name is not specified' do
      before :each do
        @container = Hypo::Container.new
        @container.register(TestType, :my_own_name)
      end

      it 'registers component and can resolve it by specified name' do
        instance = @container.resolve(:my_own_name)
        expect(instance).to be_a TestType
      end
    end

    context 'when component has already been registered' do
      before :each do
        @container = Hypo::Container.new
        @container.register(TestType)
      end

      it 'raises ContainerError with specific message' do
        message = 'Component of type "TestType" has already been registered'
        expect {@container.register(TestType)}
          .to raise_error(Hypo::ContainerError, message)
      end
    end

    context 'when register a component of the same type with different name' do
      before :each do
        @container = Hypo::Container.new
        @container.register(TestType, :test_type_one)
      end

      it 'does not raise an error' do
        expect {@container.register(TestType, :test_type_two)}
          .not_to raise_error
      end
    end

    context 'when register component as instance of an object' do
      before :each do
        @container = Hypo::Container.new
      end

      context 'when name is not specified' do
        it 'should raise ContainerError with specific message' do
          expect {@container.register(TestType.new)}
            .to raise_error(Hypo::ContainerError, 'Registered object should have a name')
        end
      end

      it 'registers component and can resolve it by type name' do
        @container.register(TestType.new, :my_object)
        instance = @container.resolve(:my_object)
        expect(instance).to be_a TestType
      end
    end

    it 'returns registered component' do
      container = Hypo::Container.new
      component = container.register(TestType)
      expect(component).to be_a Hypo::Component
    end

    it 'should be chainable for component' do
      class TestChain; end

      container = Hypo::Container.new
      component = container.register(TestType)
        .register(TestChain)

      expect(component).to be_a Hypo::Component
    end

    it 'should be chainable for instance' do
      class TestChain; end

      container = Hypo::Container.new
      component = container.register(Object.new, :chainable_instance)
                      .register(TestChain)

      expect(component).to be_a Hypo::Component
    end
  end

  describe 'resolve' do
    before :each do
      @container = Hypo::Container.new
      @container.register(TestType)
    end

    context 'when requested component is not registered' do
      it 'raises ContainerError with specific message' do
        expect {@container.resolve(:some_unknown_name)}
          .to raise_error(Hypo::ContainerError, 'Component with name "some_unknown_name" is not registered')
      end
    end

    context 'when resolving type has registered dependencies' do
      class TestType2
      end

      class TestTypeWithDependencies
        attr_reader :dependency1, :dependency2

        def initialize(test_type, test_type2)
          @dependency1 = test_type
          @dependency2 = test_type2
        end
      end


      before :each do
        @container.register(TestTypeWithDependencies)
        @container.register(TestType2)
      end

      it 'resolves instance with injected dependencies' do
        instance = @container.resolve(:test_type_with_dependencies)
        expect(instance.dependency1).to be_instance_of(TestType)
        expect(instance.dependency2).to be_instance_of(TestType2)
      end
    end

    context 'when resolving type has unknown dependency' do
      class TestTypeWithUnknownDependency
        attr_reader :dependency

        def initialize(unknown_test_type)
          @dependency = unknown_test_type
        end
      end

      before :each do
        @container.register(TestTypeWithUnknownDependency)
      end

      it 'raises ContainerError with specific message' do
        expect {@container.resolve(:test_type_with_unknown_dependency)}
          .to raise_error(Hypo::ContainerError, 'Component with name "unknown_test_type" is not registered')
      end
    end
  end

  describe 'initialize' do
    it 'registers itself' do
      container = Hypo::Container.new
      expect(container.resolve(:container)).to be_a Hypo::Container
    end
  end
end
