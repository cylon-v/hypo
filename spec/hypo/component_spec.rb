require 'spec_helper'
require 'hypo/component'
require 'hypo/container'

RSpec.describe Hypo::Component do
  before :all do
    @container = Hypo::Container.new
  end

  describe 'initialize' do
    context 'when name is not specified' do
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

    context 'when name is specified' do
      it 'uses specified name instead of creating it using type name' do
        component = Hypo::Component.new(TestType, @container, :my_own_name)
        expect(component.name).to eql :my_own_name
      end
    end
  end
end
