This documentation is for Literal Enums 2.0, which is not yet supported by Literal Enums Rails. You can see documentaiton for Literal Enums v1 [here](https://github.com/joeldrapper/literal_enums/tree/d49eeba40f01f24c6b26d4dcdc6abb0da28e9ccb#readme).

# literal_enums

Literal Enums makes Enumerations first-class citizens in Ruby, providing a literal definition syntax.

## Usage

You can define an enum by subclassing `Enum` and using the literal syntax.

```ruby
class Color < Enum
  Red
  Green
  Blue
end
```

Here we’ve enumerated `Color::Red`, `Color::Green`, and `Color::Blue` constants that reference unique instances of `Color`. You can verify this in the console:

```ruby
Color::Red.is_a?(Color) # returns true
```

Enum classes have synthetic methods for looking up their members. `Color.members` will return an `Array` of members of the `Color` enumeration: `Color::Red`, `Color::Green`, and `Color::Blue`.

Members also have polymorphic predicate methods for each member of the enumeration in lower-snake-case.

```ruby
color = Color::Red

color.red? # true
color.green? # false
```

### Values

Literal Enums can also be defined with values:

```ruby
class Color < Enum
  Red("ff0000")
  Green("00ff00")
  Blue("0000ff")
end
```

Then we can look up all the values.

```ruby
Color.values # returns an Array of ["ff0000", "00ff00", "0000f"].
```

We can also look at the value for any member directly.

```ruby
Color::Red.value # returns "ff0000"
```

Additionally, we can cast an Enum member from its value:

```ruby
Color.cast("ff0000") # returns Color::Red
```

### Singletons

When defining an enumeration, we can optionally provide a block that allows us to define methods on the singleton member. An example use-case might be a Switch that can be toggled On and Off. Whichever state its in, `toggle` will return the other state.

```ruby
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

Switch::On.toggle # returns Switch::Off
Switch::Off.toggle # returns Switch::On
```

### State machine

It is also possible to define a more complex state machine by defining `transitions_to` methods on member singletons.

```ruby
class State < Enum
  Pending -> { [Approved, Rejected] }
  Approved -> { Published }
  Rejected -> { Deleted }

  Deleted
  Published
end
```

Given the above definition, we can transition from one state to another by calling `>>` with the newly desired state. This will raise a `LiteralEnums::TransitionError` if the transition is invalid.

```ruby
State::Pending >> State::Approved # returns State::Approved.
State::Pending >> State::Published # raises a LiteralEnums::TransitionError.
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "literal_enums"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install literal_enums

### Rails

Literal Enums are compatible with Rails. Please see `literal_enums-rails`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joeldrapper/literal_enums. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LiteralEnums project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joeldrapper/literal_enums/blob/master/CODE_OF_CONDUCT.md).
