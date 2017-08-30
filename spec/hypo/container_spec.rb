require 'spec_helper'
require 'stubs/test_type'

RSpec.describe Hypo::Container do
  describe 'register' do
    it 'registers component' do
      container = Hypo::Container.new
      container.register(TestType)

      instance = container.resolve(:test_type)
      expect(instance).to be_a TestType
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
  end
end
