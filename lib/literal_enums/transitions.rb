# frozen_string_literal: true

module LiteralEnums
	module Transitions
		def >>(other)
			return self if other == self

			if transitions_to?(other)
				other
			else
				raise TransitionError,
					"You can't transition from #{name} to #{other.name}."
			end
		end

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
