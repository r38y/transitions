module Transitions
  class State
    attr_reader :name, :options

    def initialize(name, options = {})
      @name = name
      if machine = options.delete(:machine)
        define_state_query_method(machine)
      end
      update(options)
    end

    def ==(state)
      if state.is_a? Symbol
        name == state
      else
        name == state.name
      end
    end

    def call_action(action, record)
      action = @options[action]
      case action
      when Symbol, String
        record.send(action)
      when Proc
        action.call(record)
      end
    end

    def display_name
      @display_name ||= name.to_s.gsub(/_/, ' ').capitalize
    end

    def for_select
      [display_name, name.to_s]
    end

    def update(options = {})
      @display_name = options.delete(:display) if options.key?(:display)
      @options = options
      self
    end

    private
    def define_state_query_method(machine)
      method_name, state_name = "#{@name}?", @name # Instance vars are out of scope when calling define_method below, so we use local variables.
      if machine.klass.method_defined?(method_name.to_sym)
        raise InvalidMethodOverride, "Transitions: Can not define method `#{method_name}` because it is already defined - either rename the existing method or the state."
      end
      machine.klass.send :define_method, method_name do
        current_state.to_s == state_name.to_s
      end
    end
  end
end
