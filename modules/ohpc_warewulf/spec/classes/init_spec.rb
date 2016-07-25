require 'spec_helper'
describe 'ohpc_warewulf' do

  context 'with defaults for all parameters' do
    it { should contain_class('ohpc_warewulf') }
  end
end
