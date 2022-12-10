module LiteralEnums
  module Transitions
    def respond_to_missing?(name, include_private = false)
      case transitions_to
      when Enum
        transitions_to.name.to_s.demodulize.underscore.to_sym == name
      when Array
        transitions_to.any? { |m| m.name.to_s.demodulize.underscore.to_sym == name }
      end
    end

    def method_missing(name, *args, **kwargs, &block)
      case transitions_to
      when Enum
        if transitions_to.name.to_s.demodulize.underscore.to_sym == name
          return transitions_to
        end
      when Array
        if (next_one = transitions_to.find { |m| m.name.to_s.demodulize.underscore.to_sym == name })
          return next_one
        end
      end

      super
    end

    def transition_to(new_state)
      return new_state if can_transition_to?(new_state)

      raise TransitionError,
        "You can't transition from #{self.name} to #{new_state.name}."
    end

    def can_transition_to?(new_state)
      case transitions_to
      when Enum
        transitions_to == new_state
      when Array
        transitions_to.include? new_state
      end
    end

    private

    def transitions_to
      []
    end
  end
end
