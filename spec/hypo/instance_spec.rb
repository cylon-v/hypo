require 'spec_helper'
require 'hypo/component'
require 'hypo/container'
require 'hypo/life_cycle/singleton'
require 'hypo/life_cycle/transient'

RSpec.describe Hypo::Instance do
  before :all do
    @container = Hypo::Container.new
  end

  describe 'initialize' do
    context 'when name is specified' do
      it 'correctly initializes an instance' do
        instance = Hypo::Instance.new(Object.new, @container, :my_instance)
        expect(instance.name).to eql :my_instance
      end
    end

    context 'when name is not specified' do
      it 'should raise ContainerError with specific message' do
        expect {Hypo::Instance.new(Object.new, @container, nil)}
          .to raise_error(Hypo::ContainerError, 'Registered object should have a name')
      end
    end
  end

  describe 'instance' do
    it 'should return passed object' do
      object = Object.new
      instance = Hypo::Instance.new(object, @container, :my_instance)
      expect(instance.instance).to equal object
    end
  end
end
