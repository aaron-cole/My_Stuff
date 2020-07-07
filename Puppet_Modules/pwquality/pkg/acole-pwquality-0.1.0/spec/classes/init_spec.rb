require 'spec_helper'
describe 'pwquality' do
  context 'with default values for all parameters' do
    it { should contain_class('pwquality') }
  end
end
