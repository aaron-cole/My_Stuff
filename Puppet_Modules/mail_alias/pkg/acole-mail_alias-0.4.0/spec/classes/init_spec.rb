require 'spec_helper'
describe 'mail_alias' do
  context 'with default values for all parameters' do
    it { should contain_class('mail_alias') }
  end
end
