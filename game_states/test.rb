module Phitris
  class Test < NightFury::GameState
    include Config

    config tetrion_background: 0xFF001133

    class WindowTetrion < Tetrion
      def inside_width
        $window.width - padding*2
      end

      def inside_height
        $window.height - padding*2
      end
    end
    
    def initialize
      super

      # Create the window tetrion
      WindowTetrion.create(config)
    end
  end
end