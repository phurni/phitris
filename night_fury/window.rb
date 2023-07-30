module NightFury
  class Window < GameState
    attr_reader :width, :height

    def initialize(width, height, fullscreen, options = {})
      @width = width
      @height = height
      $window = self
      super(options)
    end

    def push_game_state(state)
      state.new
    end

    def show
    end
  end
end

def tick(args)
  $current_state.tick(args) if $current_state
end
