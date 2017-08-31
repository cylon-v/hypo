require 'spec_helper'
require 'hypo/component'
require 'hypo/container'

RSpec.describe Hypo::Component do
  before :all do
    @container = Hypo::Container.new
  end

  describe 'initialize' do
    it 'correctly initialize simple name' do
      component = Hypo::Component.new(TestType, @container)
      expect(component.name).to eql :test_type
    end

    it 'correctly initialize name with number' do
      class TestType2
      end

      component = Hypo::Component.new(TestType2, @container)
      expect(component.name).to eql :test_type2
    end

    it 'correctly initialize name of type with modules' do
      module TestModule
        class TestClass
        end
      end

      component = Hypo::Component.new(TestModule::TestClass, @container)
      expect(component.name).to eql :test_module_test_class
    end
  end
end
