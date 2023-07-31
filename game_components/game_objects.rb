module Phitris
  Point = Struct.new(:x, :y)
  
  Size = Struct.new(:width, :height)
  
  class Margin < Size
    include Config
    config width: 20, height: 20
    
    def self.create(*args)
      args[1] ? new(config[:width]*args[1], config[:height]*args[1]) : new(config[:width], config[:height])
    end
  end
  
  class Tetrion < NightFury::GameObject
    attr_reader :padding
    
    def initialize(options = {})
      super(options)
      
      @border_colors, @border_image = colors_and_image(options[:tetrion_border])
      @background_colors, @background_image = colors_and_image(options[:tetrion_background])
      @padding = options[:tetrion_padding] || 0
    end
    
    def draw(args)
      args.outputs.solids << to_draw_rect(x,y,width,height).rect.to_hash.merge(@border_colors.first.to_h) if @border_colors
      args.outputs.sprites << [*to_draw_rect(x, y, @border_image.width, @border_image.height), @border_image.path] if @border_image
      
      args.outputs.solids << to_draw_rect(x+padding,y+padding,inside_width,inside_height).rect.to_hash.merge(@background_colors.first.to_h) if @background_colors
      args.outputs.sprites << [*to_draw_rect(x+padding, y+padding, @background_image.width, @background_image.height), @background_image.path] if @background_image
    end
    
    def width
      @width ||= @padding*2 + inside_width
    end
    
    def height
      @height ||= @padding*2 + inside_height
    end
    
    protected
    
    def colors_and_image(tetrion_config)
      case tetrion_config
      when String
        [nil, NightFury::Image.from(tetrion_config)]
      when nil
        [nil, nil]
      else
        colors = Array(tetrion_config)
        colors *= 2 if colors.size == 1
        colors.map! {|color| NightFury::Color.from(color) }
        [colors, nil]
      end
    end
  end
  
end
