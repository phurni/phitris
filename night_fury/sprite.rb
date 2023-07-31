module NightFury
  class Sprite < GameObject
    attr_accessor :x, :y
    attr_reader :color, :image

    def initialize(options = {})
      super
      self.image =  options[:image] if options[:image]
      self.color =  options[:color] || NightFury::Color::WHITE
      self.x =      options[:x] || 0
      self.y =      options[:y] || 0
    end

    def image=(object)
      @image = NightFury::Image.from(object)
    end

    def color=(object)
      @color = NightFury::Color.from(object)
    end

    def width
      @image.width
    end

    def height
      @image.height
    end
  end
end
