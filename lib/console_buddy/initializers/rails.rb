# Load the Railtie if Rails is defined
# This is necessary so that the commands are loaded when the Rails console is started.
if defined? Rails
  require_relative "../railtie"
end