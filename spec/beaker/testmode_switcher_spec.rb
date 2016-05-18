require 'spec_helper'
require 'beaker/testmode_switcher/version'

describe Beaker::TestmodeSwitcher do
  it 'has a version number' do
    expect(Beaker::TestmodeSwitcher::VERSION).not_to be nil
  end

  it 'has a testmode' do
    expect(Beaker::TestmodeSwitcher.testmode).not_to be nil
  end
end
