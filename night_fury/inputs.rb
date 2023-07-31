module NightFury
  module Inputs
    def self.included(base)
      base.class_eval do
        alias_method :update_without_inputs, :update
        alias_method :update, :update_with_inputs
      end
    end

    def update_with_inputs(args)
      @_inputs ||= {}
      @_inputs.each do |key, method|
        send(method) if args.inputs.keyboard.key_down.send(key)
      end
      update_without_inputs(args) #super # FIXME: Re-enable when Module.prepend will work (instead of Module.include)
    end

    def inputs=(hash)
      @_inputs = hash
    end
  end
end
