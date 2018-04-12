# Hypo ![Build Status](https://travis-ci.org/cylon-v/hypo.svg?branch=master)
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
Optionally you can specify custom name for your component:
```ruby
container.register(User, :my_dear_user)
```
and then you can resolve the component as :my_dear_user:
```ruby
container.resolve(:my_dear_user)
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

Sometimes you're not able to manage a type lifetime, i.e. when you use 3rd-party static stuff, like:
```ruby
class DB
  def self.connect
    # ...
  end
end
```
In that case you can register an instance instead of a type:
```ruby
connection = DB.connect
container.register_instance(connection, :connection)    
```

## Advanced Usage 
### Component Lifetime
By default all registered components have lifetime Hypo::Lifetime::Transient (:transient). 
It means, every time when you resolve a component Hypo returns new instance of its type.
If you wanna change this behavior then you can replace lifetime strategy. 
Out of the box Hypo provides Hypo::Lifetime::Singleton (:singleton) strategy, you can use it when register a component:

```ruby
container.register(User).using_lifetime(:singleton)
``` 

#### Lifetime compatibility 
Hypo resolves components with different lifetime strategies independently. 
In other words you can inject a dependency with less lifespan than acceptor type. I.e.:

```ruby
class A; end

class B
  def initialize(type_a)
    @type_a = type_a
  end
end


container.register(A, :type_a).using_lifetime(:transient)
container.register(B, :type_b).using_lifetime(:singleton)

container.resolve(:type_b)
```

According to :transient strategy every time when you try to resolve a singleton 
you retrieve exactly the same instance of the singleton **but with new instance** of transient dependency.    

#### Custom Lifetime
Actually you can implement your own lifetime, 
i.e. makes sense to think about HttpRequest strategy for your web applications. You can do that using "add_lifetime" method:

```ruby
# somewhere in Rack application: application initialization
lifetime = Lifetime::Request.new
container.add_lifetime(lifetime, :request)
```

A class of new lifetime must respond to "instance" method. This method just a factory method which creates new instance according to your strategy. For example, Lifetime::Request could cache instanes of a components during http request lifespan. Take a look to [:singleton implementation](https://github.com/cylon-v/hypo/blob/master/lib/hypo/lifetime/singleton.rb). You can manually purge internal state of components registry according your strategy. In case of http-request lifetime you could clean up it right after request has done:

```ruby
# somewhere in Rack application: application initialization
# ...
container
  .register(SQLTransation, :transaction)
  .using_lifetime(:request)
```

```ruby
# somewhere in Rack application: request handling
container.register_instance(query_string, :query_string)

# handle the request
# ...

lifetime.purge
```

#### Lifetime :scope
For most of cases when you need to bind dependency lifetime to lifetime of another item of your application
you can use Hypo::Lifetime::Scope (:scope) strategy. In order to to that first of all you should implement a scope:

```ruby
class Request
  include Hypo::Scope
    
  def handle
    # do something
    release
    # return a result
  end
end
``` 

```ruby
# somewhere in Rack application: application initialization
# ...
container
  .register(SQLTransation, :transaction)
  .using_lifetime(:scope)
  .bound_to(:request) # you can use symbol
```

```ruby
# somewhere in Rack application: request handling
container
    .register_instance(request, :request)
    .using_lifetime(:scope)
    .bound_to(request) # the scope!

request.handle
``` 


:scope lifetime supports a finalizing for its objects. Class with such ability should respond to "finalize" method:

```ruby
class SQLTransation
  def initialize
    @transaction = DB.begin_transaction
  end
  
  def finalize
    @transaction.commit
  end
end
```
Method "finalize" calls on scope releasing (Hypo::Scope#release).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hypo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).