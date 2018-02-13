require 'spec_helper'

require 'beaker/testmode_switcher/dsl'

describe Beaker::TestmodeSwitcher::DSL do
  let(:hosts) {}
  let(:logger) {}
  let(:subject) { Beaker::TestmodeSwitcher.runner(hosts, logger) }

  describe '#create_remote_file_ex' do
    it 'is callable' do
      is_expected.to receive(:create_remote_file_ex)
      create_remote_file_ex('/tmp/foo', 'content', {})
    end
  end
  describe '#scp_to_ex' do
    it 'is callable' do
      is_expected.to receive(:scp_to_ex)
      scp_to_ex('/tmp/from', '/tmp/to')
    end
  end
  describe '#shell_ex' do
    it 'is callable' do
      is_expected.to receive(:shell_ex)
      shell_ex('cmd', {})
    end
  end
  describe '#resource' do
    it 'is callable' do
      is_expected.to receive(:resource)
      resource('type', 'name', {})
    end
  end
  describe '#execute_manifest' do
    it 'is callable' do
      is_expected.to receive(:execute_manifest)
      execute_manifest('manifest', {})
    end
  end

  describe '#execute_manifest_on' do
    it 'is callable' do
      is_expected.to receive(:execute_manifest_on)
      execute_manifest_on(hosts, 'manifest', {})
    end
  end

  describe '#runner' do
    it_behaves_like "a runner"
    it_behaves_like "a fully implemented runner"
  end
end
