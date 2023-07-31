module NightFury
  class Text < GameObject
    attr_accessor :x, :y
    attr_reader :text, :width, :height, :color

    def initialize(text, options = {})
      super(options)
      self.text = text
      self.x = options[:x] || 0
      self.y = options[:y] || 0
      self.color = options[:color] || NightFury::Color::WHITE
    end

    def text=(value)
      @text = value
      @width, @height = $gtk.calcstringbox(@text)
    end

    def color=(object)
      @color = NightFury::Color.from(object)
    end

    def draw(args)
      target_x, target_y, _, _ = to_draw_rect(x, y, 0, 0)
      args.outputs.labels << [target_x, target_y, text, 0, 0, color.red, color.green, color.blue, color.alpha]
    end
  end
end
