require 'spec_helper'
require 'tempfile'

describe Beaker::TestmodeSwitcher::LocalRunner do
  let(:subject) { described_class.new }

  it_behaves_like "a runner"
  # when run in isolation, the DSL module may not be mixed in
  it_behaves_like "a fully implemented runner" if defined?(Beaker::TestmodeSwitcher::DSL)

  describe '#create_remote_file_ex' do
    before :each do
      # create a unique filename, that does not yet exist
      tempfile = Tempfile.new('localrunner')
      @target = tempfile.path + ".txt"
      tempfile.close
      tempfile.unlink
    end

    after :each do
      File.delete(@target)
    end

    it 'creates a file with no content' do
      subject.create_remote_file_ex(@target, '')
      expect(File).to exist(@target)
    end

    it 'creates a file with content' do
      subject.create_remote_file_ex(@target, "content\n")
      expect(File.read(@target)).to eq "content\n"
    end

    it 'creates a file with mode' do
      subject.create_remote_file_ex(@target, "content\n", mode: '0700')
      mode = format("%o", File.stat(@target).mode) # rubocop:disable Style/FormatStringToken  Safe conversion in this instance
      expect(mode).to eq "100700"
    end
  end
end
