require "spec_helper"

describe Cases do
  context "when response is success" do
    let(:message) { "success response" }
    let(:response) { TestResponse.new(success: true, failed: false) }
    let(:test_cases) { TestCases.new(response) }

    it "should respond from test response" do
      expect(test_cases.test_with_block).to eq("success message from test response")
    end

    it "should respond from cased object" do
      expect(test_cases.test_without_block).to eq("success message from cased object")
    end

    it "should respond from the given block" do
      expect(test_cases.test_caseable do |on|
        on.success? { |object| "#{object.success_message} through caseable" }
        on.failed? { |object| "#{object.failed_message} through caseable" }
      end).to eq("success message from test response through caseable")
    end
  end

  context "when response is failed" do
    let(:message) { "failed response" }
    let(:response) { TestResponse.new(success: false, failed: true) }
    let(:test_cases) { TestCases.new(response) }

    it "should respond from test response" do
      expect(test_cases.test_with_block).to eq("failed message from test response")
    end

    it "should respond from cased object" do
      expect(test_cases.test_without_block).to eq("failed message from cased object")
    end

    it "should respond from the given block" do
      expect(test_cases.test_caseable do |on|
        on.success? { |object| "#{object.success_message} through caseable" }
        on.failed? { |object| "#{object.failed_message} through caseable" }
      end).to eq("failed message from test response through caseable")
    end
  end
end

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
