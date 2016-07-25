require 'spec_helper'
describe 'ohpc_slurm' do

  context 'with defaults for all parameters' do
    it { should contain_class('ohpc_slurm') }
  end
end
