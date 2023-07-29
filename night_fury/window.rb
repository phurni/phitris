module NightFury
  class Window < Object
    def push_game_state(state)
      $current_state = state.new
    end

    def show
    end
  end
end

def tick(args)
  $current_state.tick(args) if $current_state
end
