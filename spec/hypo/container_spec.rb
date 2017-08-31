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
  end
end
