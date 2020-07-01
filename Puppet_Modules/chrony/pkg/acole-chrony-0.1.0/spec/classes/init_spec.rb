require 'spec_helper'
describe 'chrony' do
  context 'with default values for all parameters' do
    it { should contain_class('chrony') }
  end
end
