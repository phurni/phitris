module Phitris
  class Caption < NightFury::Text
    include Config
    config align: :center, size: 20, color: 0xFF88ffff
    
    def initialize(parent, arg, options = {})
      super(parent.config[:captions][arg.to_s], config.merge(options))
    end
  end

  class Value < NightFury::Text
    include Config
    config align: :center, size: 20, format: '%s'

    def initialize(options = {})
      super('', config.merge(options))
      self.class.instance = self
    end
    
    def max_width=(value)
      @max_width = value.to_i
    end
    
    attr_reader :value
    def value=(v)
      @value = v.tap { self.text = format(v) }
    end
    
    def format(value)
      config[:format] % value
    end
    
    class << self
      attr_accessor :instance
      
      def value
        instance ? instance.value : @value
      end
      
      def value=(v)
        instance ? (instance.value = v) : (@value = v)
      end
    end
  end
  
  class Score < Value
  end
  
  class Lines < Value
  end
  
  class Level < Value
  end
  
  class ElapsedTime < Value
    def initialize(options = {})
      super(config.merge(options))
      @value = 0
    end
    
    def update(args)
      self.value += 16.6666666666666667 # args.state.milliseconds_since_last_tick
      super
    end
    
    def format(value)
      total = value / 1000
      "%i:%02i" % [total/60, total%60]
    end
  end
  
end
