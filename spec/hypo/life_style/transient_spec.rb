require 'spec_helper'
require 'hypo/component'
require 'hypo/life_cycle/singleton'
require 'stubs/test_type'

RSpec.describe Hypo::Transient do
  before :all do
    container = Hypo::Container.new
    component = Hypo::Component.new(TestType, container)
    @life_cycle = Hypo::Transient.new(component)
  end

  describe 'instance' do
    it 'returns component instance' do
      expect(@life_cycle.instance).to be_a TestType
    end

    context 'called twice' do
      it 'every time returns new instance' do
        instance1 = @life_cycle.instance
        instance2 = @life_cycle.instance

        expect(instance1).not_to equal instance2
      end
    end
  end
end