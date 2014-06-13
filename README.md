# Cases

Define case, and caseable callbacks for your methods in ruby. By defining cases
you can add callbacks to your methods where different callbacks will happen
based on the result of the method.

## Installation

Add this line to your application's Gemfile:

    gem 'cases'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cases

## Usage

```rb
class TestResponse
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def failed?
    options[:failed]
  end

  def failed_message
    "failed message from test response"
  end

  def success?
    options[:success]
  end

  def success_message
    "success message from test response"
  end
end

class TestCases
  include Cases

  attr_reader :response

  def initialize(response)
    @response = response
  end

  def failed_message
    "failed message from cased object"
  end

  def success_message
    "success message from cased object"
  end

  def test_with_block
    response
  end
  define_case(:test_with_block, :success?) { |response| response.success_message }
  define_case(:test_with_block, :failed?) { |response| response.failed_message }

  def test_without_block
    response
  end
  define_case(:test_without_block, success?: :success_message)
  define_case(:test_without_block, failed?: :failed_message)

  def test_caseable
    response
  end
  define_caseable(:test_caseable)
end

> # When the test response was a success
> test_response = TestResponse.new(success: true, failed: false)
> test_case = TestCases.new(test_response)
> test_case.test_with_block
 => "success message from test response"
> test_case.test_without_block
 => "success message from cased object"
> test_case.test_caseable do |on|
    on.success? { |response| "#{response.success_message} through caseable" }
    on.failed? { |response| "#{response.failed_message} through caseable" }
  end
 => "success message from test response through caseable"
>
> # When the test response failed
> test_response = TestResponse.new(success: false, failed: true)
> test_case = TestCases.new(test_response)
> test_case.test_with_block
 => "failed message from test response"
> test_case.test_without_block
 => "failed message from cased object"
> test_case.test_caseable do |on|
    on.success? { |response| "#{response.success_message} through caseable" }
    on.failed? { |response| "#{response.failed_message} through caseable" }
  end
 => "failed message from test response through caseable"
```

## Contributing

1. Fork it ( http://github.com/MorganShowman/cases/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
