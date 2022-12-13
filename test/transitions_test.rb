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

  def test_transition_to_transitions_to_valid_state
    assert_equal State::Draft >> State::PendingReview >> State::Approved, State::Approved
  end

  def test_transition_to_raises_transition_error_for_invalid_states
    error = assert_raises(LiteralEnums::TransitionError) do
      State::Draft >> State::Published
    end

    assert_equal error.message, "You can't transition from TransitionsTest::State::Draft to TransitionsTest::State::Published."
  end

  def test_transitions_to_predicate
    assert State::Draft.transitions_to?(State::PendingReview)
    refute State::Draft.transitions_to?(State::Published)
  end
end
