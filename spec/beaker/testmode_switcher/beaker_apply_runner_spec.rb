require 'spec_helper'
require 'tempfile'

describe Beaker::TestmodeSwitcher::BeakerApplyRunner do
  let(:subject) { described_class.new }

  it_behaves_like "a runner"
end
