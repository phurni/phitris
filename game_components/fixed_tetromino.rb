module Phitris
  class FixedTetromino < Tetrion
    include Config
    
    config tetrion_border: 0xFF181855, tetrion_background: 0xFF404850, tetrion_padding: 10
    
    attr_accessor :tetromino
    
    def initialize(options = {})
      super(config.merge(options))
    end
    
    def inside_width
      @inside_width ||= Tetromino.max_size*Gosu::Image[Tetromino.config[:image]].width
    end

    def inside_height
      @inside_height ||= Tetromino.max_size*Gosu::Image[Tetromino.config[:image]].height
    end
    
    def draw
      super
      if @tetromino
        @tetromino.draw_relative(x+padding+(inside_width-@tetromino.width)/2, y+padding+(inside_height-@tetromino.height)/2)
      end
    end
    
  end
  
  class NextTetromino < FixedTetromino
    def initialize(parent, tetrominos, options = {})
      super(config.merge(options))
      tetrominos << self
    end
  end
  
  class HoldTetromino < FixedTetromino
  end
  
  class NextTetrominos
    include Config
    include Layout
    
    config count: 3, layout_in: :column
    
    attr_reader :width, :height
    
    class << self
      attr_reader :instance
      
      def create(*args)
        @instance = new(*args)
      end

      def shift
        instance.shift if instance
      end
    end
    
    def initialize(options = {})
      options = config.merge(options)
      @count = options[:count]
      
      layout_method = :"layout_#{options[:layout_in]}"
      @tetrominos = []
      size = send(layout_method, options[:x], options[:y], *([{NextTetromino => @tetrominos}, Margin]*@count))
      @width, @height = size.width, size.height
    end
    
    def shift
      next_tetrominos = Tetromino.config[:randomizer].instance.next(@count)
      @tetrominos.each_with_index {|next_tet, index| next_tet.tetromino = next_tetrominos[index].new }
    end
  end
  
end
