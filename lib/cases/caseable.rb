module Cases
  class Caseable
    attr_reader :object, :runtime_block

    def initialize(object, &runtime_block)
      @object = object
      @runtime_block = runtime_block
    end

    def execute
      runtime_block.call(self)
      case_blocks.reduce(object) { |result, case_block| case_block.call(result) }
    end

    def method_missing(method, &case_block)
      case_blocks << case_block if object.send(method)
      case_blocks
    end

    private

    def case_blocks
      @_case_blocks ||= []
    end
  end
end
