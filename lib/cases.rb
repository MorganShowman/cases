require "method_callbacks"
require "cases/case"
require "cases/caseable"
require "cases/version"

module Cases
  def self.included(base)
    base.extend(MethodCallbacks::ClassMethods)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def define_case(method, cases)
      if block_given?
        define_case_with_block(method, cases, &Proc.new)
      else
        cases.each_pair do |event, action|
          Case.new(method, event, { on_self: true }, &Proc.new { |object| object.send(action) })
        end
      end

      define_execute_cases(method)
    end

    def define_caseable(method)
      proxy_result(method) { |result, &block| Caseable.execute(result, &block) }
    end

    def cases
      Case.all
    end

    private

    def define_case_with_block(method, event, &block)
      Case.new(method, event, &block)
    end

    def define_execute_cases(method)
      define_method "execute_#{method}_cases" do |&block|
        self.class.cases[method].find { |kase| kase.execute(self, block.call) }.result
      end

      around_method(method, "execute_#{method}_cases")
    end
  end
end
