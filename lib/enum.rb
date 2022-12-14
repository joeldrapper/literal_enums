class Enum
  extend Enumerable
  include LiteralEnums::Transitions

  attr_reader :name, :value

  alias_method :inspect, :name

  def initialize(name, value)
    @short_name = name.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase!
    @name = "#{self.class.name}::#{name}"
    @value = value
  end

  class << self
    attr_reader :members

    def inherited(child)
      TracePoint.new(:end) do |tp|
        if tp.self == child
          tp.self.freeze
          tp.disable
        end
      end.enable

      child.instance_eval do
        @values = {}
        @members = []
      end
    end

    def const_missing(name)
      return super if frozen?
      new(name)
    end

    def method_missing(name, *args, **kwargs, &block)
      return super if frozen?
      return super unless name[0] =~ /[A-Z]/
      new(name, *args, **kwargs, &block)
    end

    def cast(value)
      @values[value]
    end

    def values
      @values.keys
    end

    def each(&block)
      @members.each(&block)
    end

    private

    def new(name, a = nil, b = nil, &block)

      # If only one positional argument is provided and it's a proc, treat it as the transitions_to definition. Otherwise, the first argument is the value and the second argument is the transitions_to definition.

      if !b && Proc === a
        transitions_to = a
        value = name
      else
        value = a || name
        transitions_to = b
      end

      if self == Enum
        raise ArgumentError,
          "You can't add values to the abstract Enum class itself."
      end

      if const_defined?(name)
        raise ArgumentError,
          "Name conflict: '#{self.name}::#{name}' is already defined."
      end

      if @values[value]
        raise ArgumentError,
          "Value conflict: the value '#{value}' is defined for '#{self.cast(value).name}'."
      end

      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{name.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase!}?
          @short_name == "#{name.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase!}"
        end
      RUBY

      member = super(name, value)
      member.instance_eval(&block) if block_given?
      member.define_singleton_method(:transitions_to, transitions_to) if transitions_to
      member.freeze

      const_set(name, member)
      @members << member
      @values[value] = member
    end
  end
end
