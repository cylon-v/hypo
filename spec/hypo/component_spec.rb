require 'spec_helper'
require 'hypo/component'
require 'hypo/container'
require 'hypo/lifetime/singleton'
require 'hypo/lifetime/transient'

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

  describe 'use_lifetime' do
    it 'sets requested life cycle' do
      component = Hypo::Component.new(TestType, @container)

      expect(component.lifetime).to be_an_instance_of Hypo::Lifetime::Transient
      component.use_lifetime(:singleton)
      expect(component.lifetime).to be_an_instance_of Hypo::Lifetime::Singleton
    end
  end

  describe 'using_lifetime' do
    it 'is equal to use_lifetime' do
      component = Hypo::Component.new(TestType, @container)
      expect(component.method(:using_lifetime))
        .to eq(component.method(:use_lifetime))
    end
  end

  describe 'bind_to' do
    it 'binds an object' do
      obj = Object.new
      component = Hypo::Component.new(TestType, @container)
      component.bind_to(obj)

      expect(component.scope).to equal obj
    end
  end

  describe 'bound_to' do
    it 'is equal to bind_to' do
      component = Hypo::Component.new(TestType, @container)
      expect(component.method(:bound_to))
        .to eq(component.method(:bind_to))
    end
  end
end
