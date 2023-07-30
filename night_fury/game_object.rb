module NightFury
  class GameObject
    attr_accessor :x, :y, :width, :height, :color, :image

    def self.create(*args, &block)
      instance = new(*args, &block)
      $current_state.add_game_object(instance)
      instance
    end

    def initialize(options = {})
      super
      self.image =  NightFury::Image.from(options[:image]) if options[:image]
      self.color =  options[:color] ? NightFury::Color.from(options[:color]) : NightFury::Color::WHITE
      self.x =      options[:x] || 0
      self.y =      options[:y] || 0
      self.width =  options[:width] || 0
      self.height = options[:height] || 0
    end

    def destroy!
      $current_state.remove_game_object(self)
    end

    def setup(args)
    end

    def update(args)
    end

    def draw(args)
    end

    # Helper that converts the 'logical' rect (only the x and y) that uses top-left origin
    # to drawing rect that will be centered on the fixed DR viewport
    def to_draw_rect(x, y, w, h)
      @_offset_x ||= (1280 - $window.width).div 2
      @_offset_y ||= (720 - $window.height).div 2
      [@_offset_x+x, (720-y-h)-@_offset_y, w, h]
    end
  end
end
