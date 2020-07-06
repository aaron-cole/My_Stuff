require 'spec_helper'
describe 'journald_conf' do
  context 'with default values for all parameters' do
    it { should contain_class('journald_conf') }
  end
end
