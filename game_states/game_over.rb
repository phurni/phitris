module Phitris
  class GameOver < Chingu::GameState
    def initialize(options = {})
      super
      @color = Gosu::Color.new(128,0,0,0)
      Chingu::Text.create(:text => "GAME OVER\n\nPress any key for the menu", :size => 30, :align => :center, :rotation_center => :center_center, :x => $window.width/2, :y => $window.height/2, :zorder => Chingu::DEBUG_ZORDER + 1)
    end

    def button_down(id)
      pop_game_state(:setup => false)
      pop_game_state
    end

    def draw
      previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
      fill(@color, Chingu::DEBUG_ZORDER)
      super
    end  
  end
end
