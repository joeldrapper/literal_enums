class Enum
  extend Enumerable
  include LiteralEnums::Transitions

  attr_reader :name, :value

  alias_method :inspect, :name

  def initialize(name, value)
    @short_name = name.to_s.underscore
    @name = "#{self.class.name}::#{name}"
    @value = value
  end

  class << self
    attr_accessor :members

    def inherited(child)
      child.instance_eval do
        @values = {}
        @members = []
      end
    end

    def method_missing(name, *args, **kwargs, &block)
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

    def new(name, value = name, &block)
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
        def #{name.to_s.underscore}?
          @short_name == "#{name.to_s.underscore}"
        end
      RUBY

      member = super(name, value)
      member.instance_eval(&block) if block_given?
      member.freeze

      const_set(name, member)
      @members << member
      @values[value] = member
    end
  end
end
