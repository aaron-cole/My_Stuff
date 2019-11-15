require 'spec_helper'
describe 'rhel7_audit_stigs' do
  context 'with default values for all parameters' do
    it { should contain_class('rhel7_audit_stigs') }
  end
end
