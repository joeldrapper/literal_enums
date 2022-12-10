require "active_support"
require "active_support/core_ext/string"

require "literal_enums/version"
require "literal_enums/transitions"
require "enum"

module LiteralEnums
  Error = Module.new
  StandardError = Class.new(StandardError) { include Error }
  TransitionError = Class.new(StandardError) { include Error }
end
