# frozen_string_literal: true

require "test_helper"

class TransitionsTest < Minitest::Test
	class State < Enum
		Draft -> { [PendingReview, Deleted] }
		PendingReview -> { [Approved, Rejected] }
		Approved -> { Published }

		Rejected
		Published
		Deleted
	end

	def test_transition_to_valid_state
		assert_equal State::Approved, (State::Draft >> State::PendingReview >> State::Approved)
	end

	def test_transition_to_self
		assert_equal State::Approved, (State::Approved >> State::Approved)
	end

	def test_transition_to_invalid_states
		error = assert_raises(LiteralEnums::TransitionError) do
			State::Draft >> State::Published
		end

		assert_equal "You can't transition from TransitionsTest::State::Draft to TransitionsTest::State::Published.", error.message
	end

	def test_transitions_to_predicate
		assert State::Draft.transitions_to?(State::PendingReview)
		refute State::Draft.transitions_to?(State::Published)
	end
end
