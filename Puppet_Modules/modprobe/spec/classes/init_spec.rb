require 'spec_helper'
describe 'modprobe' do
  context 'with default values for all parameters' do
    it { should contain_class('modprobe') }
  end
end
