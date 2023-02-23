# frozen_string_literal: true

require "literal_enums"

class State < Enum
	Draft -> { [PendingReview, Deleted] }
	PendingReview -> { [Approved, Rejected] }
	Approved -> { Published }

	Rejected
	Published
	Deleted
end

test "transitioning to a valid state" do
	expect(State::Draft >> State::PendingReview >> State::Approved) == State::Approved
end

test "transitioning to self" do
	expect(State::Approved >> State::Approved) == State::Approved
end

test "transitioning to illegal states" do
	expect { State::Draft >> State::Published }.to_raise(LiteralEnums::TransitionError) do |error|
		expect(error.message) == "You can't transition from #{State::Draft.name} to #{State::Published.name}."
	end
end

test "transitions_to? predicate" do
	assert State::Draft.transitions_to?(State::PendingReview)
	refute State::Draft.transitions_to?(State::Published)
end
