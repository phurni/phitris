module NightFury
  class Text < GameObject
    def initialize(label, options = {})
      super(options)
    end

    def width
      50
    end
    def height
      20
    end
  end
end
