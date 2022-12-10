module LiteralEnums
  module Transitions
    def transition_to(new_state)
      if transitions_to?(new_state)
        new_state
      else
        raise TransitionError,
          "You can't transition from #{self.name} to #{new_state.name}."
      end
    end

    alias_method :>>, :transition_to

    def transitions_to?(new_state)
      possible_states = transitions_to

      case possible_states
      when Enum
        possible_states == new_state
      when Array
        possible_states.include?(new_state)
      end
    end

    private

    def transitions_to
      []
    end
  end
end
