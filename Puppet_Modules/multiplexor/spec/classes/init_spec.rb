require 'spec_helper'
describe 'multiplexor' do
  context 'with default values for all parameters' do
    it { should contain_class('multiplexor') }
  end
end
