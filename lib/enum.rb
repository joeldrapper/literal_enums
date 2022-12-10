class Enum
  extend Enumerable
  include LiteralEnums::Transitions

  attr_reader :name, :value

  alias_method :inspect, :name

  def initialize(name, value)
    @name = "#{self.class.name}::#{name}"
    @value = value || @name
  end

  class << self
    def method_missing(name, *args, **kwargs, &block)
      return super unless name[0] == name[0].upcase
      new(name, *args, **kwargs, &block)
    end

    def cast(value)
      @values[value]
    end

    def values
      map(&:value)
    end

    def each(&block)
      @members.each(&block) if defined?(@members)
    end

    def members
      return @members if defined?(@members)
      @members = []
    end

    private

    def new(name, value = nil, &block)
      if self == Enum
        raise ArgumentError,
          "You can't add values to the abstract Enum class itself."
      end

      if const_defined?(name)
        raise ArgumentError,
          "Name conflict: '#{self.name}::#{name}' is already defined."
      end

      if values.include?(value)
        raise ArgumentError,
          "Value conflict: the value '#{value}' is defined for '#{self.cast(value).name}'."
      end

      member = super(name, value)
      member.instance_eval(&block) if block_given?

      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{name.to_s.underscore}?
          name.demodulize.underscore == "#{name.to_s.underscore}"
        end
      RUBY

      member.freeze

      const_set(name, member)
      (@members ||= []) << member
      (@values ||= {})[value] = member
    end
  end
end
