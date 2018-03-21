require 'beaker/testmode_switcher'

# automatically load any shared examples or contexts
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

def windows_platform?
  # Ruby only sets File::ALT_SEPARATOR on Windows and the Ruby standard
  # requiring features to be initialized and without side effect.
  !!File::ALT_SEPARATOR # rubocop:disable Style/DoubleNegation  Completely expected in this instance
end
