require "test_helper"

class EnumTest < Minitest::Test
  class Color < Enum
    Red("ff0000")
    Green("00ff00")
    Blue("0000ff")
  end

  class Status < Enum
    Draft
    Published
  end

  class Switch < Enum
    On do
      def toggle
        Off
      end
    end

    Off do
      def toggle
        On
      end
    end
  end

  def test_frozen_classes
    assert Color.frozen?
    assert Status.frozen?
    assert Switch.frozen?
  end

  def test_frozen_members
    assert Color::Red.frozen?
    assert Color::Green.frozen?
    assert Color::Blue.frozen?

    assert Status::Draft.frozen?
    assert Status::Published.frozen?

    assert Switch::On.frozen?
    assert Switch::Off.frozen?
  end

  def test_value
    assert_equal "ff0000", Color::Red.value
    assert_equal "00ff00", Color::Green.value
    assert_equal "0000ff", Color::Blue.value

    assert_equal :Draft, Status::Draft.value
    assert_equal :Published, Status::Published.value
  end

  def test_name
    assert_equal Color::Red.name, "EnumTest::Color::Red"
    assert_equal Color::Green.name, "EnumTest::Color::Green"
    assert_equal Color::Blue.name, "EnumTest::Color::Blue"
  end

  def test_cast
    assert_equal Color.cast("ff0000"), Color::Red
    assert_equal Color.cast("00ff00"), Color::Green
    assert_equal Color.cast("0000ff"), Color::Blue
  end

  def test_values
    assert_equal Color.values, [
      "ff0000",
      "00ff00",
      "0000ff"
    ]
  end

  def test_members
    assert_equal Color.members, [
      Color::Red,
      Color::Green,
      Color::Blue
    ]
  end

  def test_singleton_definition
    assert_equal Switch::On.toggle, Switch::Off
    assert_equal Switch::Off.toggle, Switch::On
  end

  def test_disallows_duplicate_names
    error = assert_raises(ArgumentError) { Color.send(:new, :Red) }

    assert_equal "Name conflict: 'EnumTest::Color::Red' is already defined.", error.message
  end

  def test_disallows_member_definition_on_base_class
    error = assert_raises(ArgumentError) { Enum.send(:new, :Anything) }

    assert_equal "You can't add values to the abstract Enum class itself.", error.message
  end

  def test_disallows_duplicate_values
    error = assert_raises(ArgumentError) { Color.send(:new, :Anything, "ff0000") }

    assert_equal "Value conflict: the value 'ff0000' is defined for 'EnumTest::Color::Red'.", error.message
  end

  def test_only_accepts_capitalised_defintions
    assert_raises(NoMethodError) { Color.purple("800080") }
  end

  def test_predicate
    assert Color::Red.red?

    refute Color::Red.green?
    refute Color::Red.blue?
  end
end
