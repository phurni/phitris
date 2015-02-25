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
  
  class Tetrion < Chingu::BasicGameObject
    traits :simple_sprite
    include Chingu::Helpers::GFX

    attr_reader :padding
    
    def initialize(options = {})
      super(options)
      
      @border_colors, @border_image = colors_and_image(options[:tetrion_border])
      @background_colors, @background_image = colors_and_image(options[:tetrion_background])
      @padding = options[:tetrion_padding] || 0
    end
    
    def draw
      fill_gradient(:rect => [x,y,width,height], :from => @border_colors.first, :to => @border_colors.last, :zorder => zorder-1) if @border_colors
      @border_image.draw(x, y, zorder-1, width.to_f/@border_image.width.to_f, height.to_f/@border_image.height.to_f, Gosu::Color::WHITE, :default) if @border_image
      
      fill_gradient(:rect => [x+padding,y+padding,inside_width,inside_height], :from => @background_colors.first, :to => @background_colors.last, :zorder => zorder-1) if @background_colors
      @background_image.draw(x+padding, y+padding, zorder-1, inside_width.to_f/@background_image.width.to_f, inside_height.to_f/@background_image.height.to_f, Gosu::Color::WHITE, :default) if @background_image
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
        [nil, Gosu::Image[tetrion_config]]
      when nil
        [nil, nil]
      else
        colors = Array(tetrion_config)
        colors *= 2 if colors.size == 1
        [colors, nil]
      end
    end
  end
  
end
