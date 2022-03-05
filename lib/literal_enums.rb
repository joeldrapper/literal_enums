require "active_support"
require "active_support/core_ext/string"

require "literal_enums/version"
require "literal_enums/transitions"
require "enum"

module LiteralEnums
  class Error < StandardError; end
  class TransitionError < Error; end
end
