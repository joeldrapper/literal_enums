class Enum
  extend Enumerable
  include LiteralEnums::Transitions

  attr_reader :name, :value

  alias_method :to_s, :value
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
      members.find { |v| v.value == value.to_s }
    end

    def values
      map(&:value).to_set
    end

    def each(&block)
      members.each(&block)
    end

    def members
      constants.map { |c| const_get(c) }.to_set
    end

    private

    def new(name, value = nil, &block)
      if self == Enum
        raise ArgumentError, "You can't add values to the abstract Enum class itself."
      end

      if constants.include?(name)
        raise ArgumentError, "Name conflict: '#{self.name}::#{name}' is already defined."
      end

      if values.include?(value)
        raise ArgumentError, "Value conflict: the value '#{value}' is defined for '#{self.cast(value).name}'."
      end

      member = super(name, value)
      member.instance_eval(&block) if block_given?

      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{name.to_s.underscore}?
          name.demodulize.underscore == "#{name.to_s.underscore}"
        end
      RUBY

      const_set(name, member.freeze)
    end
  end
end
