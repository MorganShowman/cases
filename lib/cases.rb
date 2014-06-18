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
    def define_case(method, kase)
      block_given? ? __cases_define_with_block(method, kase, &Proc.new) : __cases_define_without_block(method, kase)

      __cases_define_execute_cases(method)
    end

    def define_caseable(method)
      proxy_result(method) { |result, &runtime_block| Cases::Caseable.new(result, &runtime_block).execute }
    end

    private

    def __cases_define_with_block(method, *events, &action_block)
      events.each { |event| Cases::Case.new(method, event, &action_block) }
    end

    def __cases_define_without_block(method, kase)
      kase.each_pair do |event, action|
        Cases::Case.new(method, event, { on_self: true }, &Proc.new { |object| object.send(action) })
      end
    end

    def __cases_define_execute_cases(method)
      define_method "__cases_execute_#{method}_cases" do |&block|
        Cases::Case.all[method].find { |kase| kase.execute(self, block.call) }.result
      end

      around_method(method, "__cases_execute_#{method}_cases")
    end
  end
end
