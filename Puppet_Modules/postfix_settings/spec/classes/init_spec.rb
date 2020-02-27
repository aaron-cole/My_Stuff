require 'spec_helper'
describe 'postfix_settings' do
  context 'with default values for all parameters' do
    it { should contain_class('postfix_settings') }
  end
end
