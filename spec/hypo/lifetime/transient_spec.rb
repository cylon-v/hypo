require 'spec_helper'
require 'hypo/component'
require 'hypo/lifetime/singleton'
require 'stubs/test_type'

RSpec.describe Hypo::Lifetime::Transient do
  before :all do
    container = Hypo::Container.new
    @component = Hypo::Component.new(TestType, container)
    @lifetime = Hypo::Lifetime::Transient.new
  end

  describe 'instance' do
    it 'returns component instance' do
      expect(@lifetime.instance(@component)).to be_a TestType
    end

    context 'called twice' do
      it 'every time returns new instance' do
        instance1 = @lifetime.instance(@component)
        instance2 = @lifetime.instance(@component)

        expect(instance1).not_to equal instance2
      end
    end
  end
end