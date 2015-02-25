module Phitris
  # Patch Chingu, width handling with max_width and background is not correct.
  class ChinguText < Chingu::Text
    def width
      max_width || super
    end
  end
  
  class Caption < ChinguText
    include Config
    config align: :center, size: 20, color: 0xFF88ffff
    
    # Will be set after creation, so re-create the image
    def max_width=(value)
      @max_width = value.to_i
      create_image
      @max_width
    end
    
    def initialize(parent, arg, options = {})
      super(parent.config[:captions][arg.to_s], config.merge(options))
    end
  end

  class Value < ChinguText
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
    
    def update
      self.value += $window.milliseconds_since_last_tick
      super
    end
    
    def format(value)
      total = value / 1000
      "%i:%02i" % [total/60, total%60]
    end
  end
  
end
