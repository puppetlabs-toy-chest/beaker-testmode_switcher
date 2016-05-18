require 'spec_helper'
require 'tempfile'

describe Beaker::TestmodeSwitcher::BeakerAgentRunner do
  let(:hosts) {}
  let(:logger) {}
  let(:subject) { described_class.new :hosts, :logger }

  it_behaves_like "a runner"
end
