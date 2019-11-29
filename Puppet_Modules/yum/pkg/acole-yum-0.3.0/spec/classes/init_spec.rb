require 'spec_helper'
describe 'yum' do
  context 'with default values for all parameters' do
    it { should contain_class('yum') }
  end
end
