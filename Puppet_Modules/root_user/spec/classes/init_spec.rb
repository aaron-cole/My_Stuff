require 'spec_helper'
describe 'root_user' do
  context 'with default values for all parameters' do
    it { should contain_class('root_user') }
  end
end
