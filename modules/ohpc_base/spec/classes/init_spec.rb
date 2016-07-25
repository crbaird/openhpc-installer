require 'spec_helper'
describe 'ohpc_base' do

  context 'with defaults for all parameters' do
    it { should contain_class('base') }
  end
end
