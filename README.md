[![Build Status](https://travis-ci.org/equivalent/simple_listener.svg)](https://travis-ci.org/equivalent/simple_listener)
[![Code Climate](https://codeclimate.com/github/equivalent/simple_listener/badges/gpa.svg)](https://codeclimate.com/github/equivalent/simple_listener)

# SimpleListener

Simplest most light-weight possible implementation of Listener / Observer.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_listener'

And then execute:

    $ bundle

## Plain Ruby usage:

```
class Book
  attr_accessor :author_name

  def save
    call_listeners(:before_create)
    # ... + do some database stuff
  end
end

class AssignAuthorListener
  def initialize(user)
    @user = user
  end

  def before_create(resource)
    resource.author_name = user.name
  end
end

require 'ostruct'
class DummyController
  def create
    @book = Book.new
    @book.add_listener(AssignAuthorListener.new(current_user))
    @book.save

    # @book.author_name # => Tomas
  end

  def current_user
    OpenStruct.new(name: "Tomas")
  end
end
```

## Ruby on Rails usage


since Rails 3.something you have the option to do `around_save`.

```
class Book < ActiveRecord::Base
  around_save :notify_listeners

  def notify_listeners
    is_create_save   = !persisted?
    if is_create_save
      call_listeners(:before_create)
    else
      call_listeners(:before_update)
    end

    yield # will do the actual saving to DB ...call :save

    if is_create_save
      call_listeners(:on_create)
    else
      call_listeners(:on_update)
    end
  end
end
```

## Credit

Idea for this gem is based on pattern shown in Avdi Grimm Ruby Tapas episode #031 Observer Variations

All hail Avdi !!!

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_listener/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
