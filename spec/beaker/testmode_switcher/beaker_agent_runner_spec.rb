require 'spec_helper'
require 'tempfile'

describe Beaker::TestmodeSwitcher::BeakerAgentRunner do
  let(:hosts) {}
  let(:logger) {}
  let(:subject) { described_class.new :hosts, :logger }

  it_behaves_like "a runner"
  # when run in isolation, the DSL module may not be mixed in
  it_behaves_like "a fully implemented runner" if defined?(Beaker::TestmodeSwitcher::DSL)
end
