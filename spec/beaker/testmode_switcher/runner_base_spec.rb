require 'spec_helper'

describe Beaker::TestmodeSwitcher::RunnerBase do
  subject { Beaker::TestmodeSwitcher::RunnerBase.new }

  context 'get_acceptable_puppet_run_exit_codes' do
    context ':catch_changes option passed' do
      it 'exit code of 0 given' do
        expect(subject.get_acceptable_puppet_run_exit_codes(catch_changes: true)).to eq([0])
      end
    end

    context ':catch_changes option passed' do
      it 'exit codes of 0 & 2 given' do
        expect(subject.get_acceptable_puppet_run_exit_codes(catch_failures: true)).to eq([0, 2])
      end
    end

    context ':catch_changes option passed' do
      it 'exit codes 1, 4 & 6 given' do
        expect(subject.get_acceptable_puppet_run_exit_codes(expect_failures: true)).to eq([1, 4, 6])
      end
    end

    context ':catch_changes option passed' do
      it 'exit code of 2 given' do
        expect(subject.get_acceptable_puppet_run_exit_codes(expect_changes: true)).to eq([2])
      end
    end

    context 'no options passed' do
      it 'exit codes 0 - 256 given' do
        expect(subject.get_acceptable_puppet_run_exit_codes).to eq((0...256))
      end
    end
  end

  context 'handle_puppet_run_returned_exit_code' do
    it 'throws UnacceptableExitCodeError when unacceptable exit code given' do
      expect { subject.handle_puppet_run_returned_exit_code([0, 2], 5) }.to raise_error(Beaker::TestmodeSwitcher::UnacceptableExitCodeError, /Unacceptable exit code returned/i)
    end

    it 'throws UnacceptableExitCodeError when unacceptable exit code given for a range' do
      expect { subject.handle_puppet_run_returned_exit_code((0..2), 5) }.to raise_error(Beaker::TestmodeSwitcher::UnacceptableExitCodeError, /Unacceptable exit code returned/i)
    end

    it 'not throw when acceptable exit code given' do
      expect { subject.handle_puppet_run_returned_exit_code([0, 2], 2) }.not_to raise_error
    end

    it 'not throw when acceptable exit code given for a range' do
      expect { subject.handle_puppet_run_returned_exit_code((0..10), 2) }.not_to raise_error
    end
  end
end
