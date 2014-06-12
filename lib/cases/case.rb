module Cases
  class Case
    attr_accessor :result
    attr_reader :method, :event, :options, :block

    def self.all
      @_all ||= {}
    end

    def initialize(method, event, options = {}, &block)
      @method = method
      @event = event
      @block = block
      @options = options

      register
    end

    def ==(other)
      method == other.method &&
        event == other.event
    end

    def execute(object, result)
      return if !result.send(event)

      self.result = block.call(options[:on_self] ? object : result)
    end

    private

    def register
      cases << self if !registered?
    end

    def registered?
      cases.any? { |kase| kase == self }
    end

    def cases
      self.class.all[method] ||= []
    end
  end
end
