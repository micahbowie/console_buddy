# Load Byebug if it's defined and the user wants to use it.
if defined? Byebug && ConsoleBuddy.use_in_debuggers
  ConsoleBuddy.load_byebug!
end