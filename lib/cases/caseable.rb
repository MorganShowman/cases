class Caseable
  attr_reader :object

  def self.execute(result, &block)
    new(result).execute(result, &block)
  end

  def initialize(object)
    @object = object
  end

  def execute(original_result, &block)
    block.call(self)
    case_blocks.reduce(original_result) { |result, case_block| case_block.call(result) }
  end

  def method_missing(method, &block)
    case_blocks << block if object.send(method)
    case_blocks
  end

  private

  def case_blocks
    @_case_blocks ||= []
  end
end
