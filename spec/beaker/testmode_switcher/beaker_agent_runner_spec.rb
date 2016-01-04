require 'spec_helper'
require 'tempfile'

describe Beaker::TestmodeSwitcher::BeakerAgentRunner do
  let(:subject) { described_class.new }

  it_behaves_like "a runner"
end
