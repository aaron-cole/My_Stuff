require 'spec_helper'
describe 'shadow' do
  context 'with default values for all parameters' do
    it { should contain_class('shadow') }
  end
end
