module LiteralEnums
  module Transitions
    def respond_to_missing?(name, include_private = false)
      return false if name == :transitions_to
      valid_next_states.any? { |m| m.name.to_s.demodulize.underscore.to_sym == name }
    end

    def method_missing(name, *args, **kwargs, &block)
      valid_next_states.find { |m| m.name.to_s.demodulize.underscore.to_sym == name } || super
    end

    def transition_to(new_state)
      return new_state if can_transition_to?(new_state)

      raise TransitionError, "You can't transition from #{self.name} to #{new_state.name}."
    end

    def can_transition_to?(new_state)
      unless new_state.is_a?(self.class)
        raise ArgumentError "You can only transition to another #{self.class.name}."
      end

      valid_next_states.include?(new_state)
    end

    private

    def valid_next_states
      return Array(transitions_to) if respond_to? :transitions_to
      []
    end
  end
end
