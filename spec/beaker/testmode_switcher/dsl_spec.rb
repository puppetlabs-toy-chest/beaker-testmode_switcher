require 'spec_helper'

require 'beaker/testmode_switcher/dsl'

describe Beaker::TestmodeSwitcher::DSL do
  let(:hosts) {}
  let(:logger) {}

  describe '#create_remote_file_ex' do
    it 'is callable' do
      expect(Beaker::TestmodeSwitcher.runner(hosts, logger)).to receive(:create_remote_file_ex)
      create_remote_file_ex('/tmp/foo', 'content', {})
    end
  end
  describe '#scp_to_ex' do
    it 'is callable' do
      expect(Beaker::TestmodeSwitcher.runner(hosts, logger)).to receive(:scp_to_ex)
      scp_to_ex('/tmp/from', '/tmp/to')
    end
  end
  describe '#shell_ex' do
    it 'is callable' do
      expect(Beaker::TestmodeSwitcher.runner(hosts, logger)).to receive(:shell_ex)
      shell_ex('cmd', {})
    end
  end
  describe '#resource' do
    it 'is callable' do
      expect(Beaker::TestmodeSwitcher.runner(hosts, logger)).to receive(:resource)
      resource('type', 'name', {})
    end
  end
  describe '#execute_manifest' do
    it 'is callable' do
      expect(Beaker::TestmodeSwitcher.runner(hosts, logger)).to receive(:execute_manifest)
      execute_manifest('manifest', {})
    end
  end

  describe '#runner' do
    let(:subject) { Beaker::TestmodeSwitcher.runner(hosts, logger) }
    it_behaves_like "a runner"
  end
end
