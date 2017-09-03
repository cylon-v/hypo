require 'spec_helper'
require 'hypo/component'
require 'hypo/life_style/singleton'
require 'stubs/test_type'

RSpec.describe Hypo::Transient do
  before :all do
    container = Hypo::Container.new
    component = Hypo::Component.new(TestType, container)
    @lifestyle = Hypo::Transient.new(component)
  end

  describe 'instance' do
    it 'returns component instance' do
      expect(@lifestyle.instance).to be_an_instance_of TestType
    end

    describe 'called twice' do
      it 'every time returns new instance' do
        instance1 = @lifestyle.instance
        instance2 = @lifestyle.instance

        expect(instance1).not_to equal instance2
      end
    end
  end
end