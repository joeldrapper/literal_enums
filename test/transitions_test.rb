require "test_helper"

class TransitionsTest < Minitest::Test
  class State < Enum
    Draft do
      def transitions_to
        [PendingReview, Deleted]
      end
    end

    PendingReview do
      def transitions_to
        [Approved, Rejected]
      end
    end

    Approved do
      def transitions_to
        [Published]
      end
    end

    Rejected()
    Published()
    Deleted()
  end

  def test_transition_to_transitions_to_valid_state
    assert_equal State::Draft.transition_to(State::PendingReview), State::PendingReview
  end

  def test_transition_to_raises_transition_error_for_invalid_states
    error = assert_raises(LiteralEnums::TransitionError) do
      State::Draft.transition_to(State::Published)
    end

    assert_equal error.message, "You can't transition from TransitionsTest::State::Draft to TransitionsTest::State::Published."
  end

  def test_responds_to_transition_methods
    assert State::Draft.respond_to? :pending_review
    refute State::Draft.respond_to? :published
  end

  def test_transition_with_methods
    assert_equal State::Draft.pending_review, State::PendingReview
    assert_raises(NoMethodError) { State::Draft.published }
  end

  def test_can_transition_to
    assert State::Draft.can_transition_to?(State::PendingReview)
    refute State::Draft.can_transition_to?(State::Published)
  end
end
