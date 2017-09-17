require 'spec_helper'
require 'hypo/component'
require 'hypo/life_cycle/singleton'
require 'stubs/test_type'

RSpec.describe Hypo::LifeCycle::Transient do
  before :all do
    container = Hypo::Container.new
    @component = Hypo::Component.new(TestType, container)
    @life_cycle = Hypo::LifeCycle::Transient.new
  end

  describe 'instance' do
    it 'returns component instance' do
      expect(@life_cycle.instance(@component)).to be_a TestType
    end

    context 'called twice' do
      it 'every time returns new instance' do
        instance1 = @life_cycle.instance(@component)
        instance2 = @life_cycle.instance(@component)

        expect(instance1).not_to equal instance2
      end
    end
  end
end