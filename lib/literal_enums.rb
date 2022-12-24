# frozen_string_literal: true

require "literal_enums/version"
require "literal_enums/transitions"
require "enum"

module LiteralEnums
	Error = Module.new
	StandardError = Class.new(StandardError) { include Error }
	TransitionError = Class.new(StandardError) { include Error }
end
