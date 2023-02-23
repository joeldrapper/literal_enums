# frozen_string_literal: true

require "literal_enums"

class Color < Enum
	Red("ff0000")
	Green("00ff00")
	Blue("0000ff")
end

class Status < Enum
	Draft
	PendingReview
	Published
end

class Switch < Enum
	On do
		def toggle
			Off
		end
	end

	Off do
		def toggle
			On
		end
	end
end

test "enum classes should be frozen after definition" do
	assert Color.frozen?
	assert Status.frozen?
	assert Switch.frozen?
end

test "enum members should be frozen" do
	assert Color::Red.frozen?
	assert Color::Green.frozen?
	assert Color::Blue.frozen?

	assert Status::Draft.frozen?
	assert Status::Published.frozen?

	assert Switch::On.frozen?
	assert Switch::Off.frozen?
end

test "enum members with custom values" do
	expect(Color::Red.value) == "ff0000"
	expect(Color::Green.value) == "00ff00"
	expect(Color::Blue.value) == "0000ff"
end

test "enum members with default values" do
	expect(Status::Draft.value) == :Draft
	expect(Status::Published.value) == :Published
end

test "enum member names" do
	expect(Color::Red.name) == "#{Color.name}::Red"
	expect(Color::Green.name) == "#{Color.name}::Green"
	expect(Color::Blue.name) == "#{Color.name}::Blue"
end

test "cast" do
	expect(Color.cast("ff0000")) == Color::Red
	expect(Color.cast("00ff00")) == Color::Green
	expect(Color.cast("0000ff")) == Color::Blue
end

test "values" do
	expect(Color.values) == ["ff0000", "00ff00", "0000ff"]
end

test "members" do
	expect(Color.members) == [Color::Red, Color::Green, Color::Blue]
end

test "singleton definition" do
	expect(Switch::On.toggle) == Switch::Off
	expect(Switch::Off.toggle) == Switch::On
end

test "disallow duplicate names" do
	expect { Color.send(:new, :Red) }.to_raise(ArgumentError) do |error|
		expect(error.message) == "Name conflict: '#{Color::Red.name}' is already defined."
	end
end

test "disallow memeber definitions on base" do
	expect { Enum.send(:new, :Anything) }.to_raise(ArgumentError) do |error|
		expect(error.message) == "You can't add values to the abstract Enum class itself."
	end
end

test "disallow duplicate values" do
	expect { Color.send(:new, :Anything, "ff0000") }.to_raise(ArgumentError) do |error|
		expect(error.message) == "Value conflict: the value 'ff0000' is defined for '#{Color::Red.name}'."
	end
end

test "member predicates" do
	assert Status::PendingReview.pending_review?
	refute Status::Draft.pending_review?
end
