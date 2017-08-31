require 'spec_helper'
require 'stubs/test_type'
require 'hypo/container_error'

RSpec.describe Hypo::Container do
  describe 'register' do
    before :each do
      @container = Hypo::Container.new
      @container.register(TestType)
    end

    it 'registers component' do
      instance = @container.resolve(:test_type)
      expect(instance).to be_a TestType
    end

    context 'when component has already been registered' do
      it 'raises ContainerError with specific message' do
        expect {@container.register(TestType)}
            .to raise_error(Hypo::ContainerError, 'Component of type "TestType" has already been registered')
      end
    end
  end

  describe 'resolve' do
    before :each do
      @container = Hypo::Container.new
      @container.register(TestType)
    end

    context 'twice' do
      it 'resolves exactly the same instance' do
        instance1 = @container.resolve(:test_type)
        instance2 = @container.resolve(:test_type)
        expect(instance1).to equal instance2
      end
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
        attr_reader :dependency_1, :dependency_2

        def initialize(test_type, test_type2)
          @dependency_1 = test_type
          @dependency_2 = test_type2
        end
      end


      before :each do
        @container.register(TestTypeWithDependencies)
        @container.register(TestType2)
      end

      it 'resolves instance with injected dependencies' do
        instance = @container.resolve(:test_type_with_dependencies)
        expect(instance.dependency_1).to be_instance_of(TestType)
        expect(instance.dependency_2).to be_instance_of(TestType2)
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
end
