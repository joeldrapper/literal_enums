#!/usr/bin/env ruby
# frozen_string_literal: true

require "literal_enums"
require "benchmark/ips"

class Color < Enum
	Red("#f00")
	Green("#0f0")
	Blue("#00f")
end

Benchmark.ips do |x|
	x.report("Cast") { Color.cast("f00") }
	x.report("Lookup") { Color::Red }
	x.report("Members") { Color.members }
	x.report("Values") { Color.values }
end
