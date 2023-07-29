module Phitris
  class Test < NightFury::GameState
    include Config

    config tetrion_background: "play_background.png"

    class WindowTetrion < Tetrion
      def inside_width
        1280 - padding*2
      end

      def inside_height
        720 - padding*2
      end
    end
    
    def initialize
      super

      # Create the window tetrion
      WindowTetrion.create(config)
    end
  end
end