# Hypo ![Build Status](https://travis-ci.org/cylon-v/hypo.svg)
Hypo is sinless general purpose IoC container for Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hypo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hypo

## Getting Started

First of all you need to create an instance of Hypo::Container.
```ruby
  container = Hypo::Container.new
```
Then you can register your types (classes) there:
```ruby
  container.register(User)
```
..and resolve them:
```ruby
  container.resolve(:user)
```
Registered types can have some dependencies that will be resolved automatically if they're registered in the container. For example, you have classes:

```ruby
class User
  attr_reader :company
  def initialize(company)
    @company = company
  end
end

class Company
end
```

and if you registered both of them, you can do:

```ruby
  user = container.resolve(:user)
  
  # user.company is resolved as well
```

## Component Lifetime
By default all registered components have lifestyle Hypo::Transient. 
It means, every time when you resolve a component Hypo returns new instance of its type.
If you wanna change this behavior then you can replace lifetime strategy. 
Out of the box Hypo provides Hypo::Singleton strategy, you can use it when register a component:

```ruby
container.register(User).using_lifestyle(Hypo::Singleton)
``` 
Actually you can implement you own lifestyle, 
i.e. makes sense to think about HttpRequest strategy for your web applications.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hypo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
