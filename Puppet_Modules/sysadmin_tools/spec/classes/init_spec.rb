require 'spec_helper'
describe 'sysadmin_tools' do
  context 'with default values for all parameters' do
    it { should contain_class('sysadmin_tools') }
  end
end
