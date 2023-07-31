# PHITRIS: A Tetris clone using DragonRuby
# August 2023

require 'lib/require_dir'

# load meta components
require_dir './lib'

# load the NightFury game lib
require_dir './night_fury', first: %w{inputs game_object}

# namespace our program, a sane habit
module Phitris
  
  # define and load pluggable modules
  include Plugger
  plug :randomizers, :rotators, :line_clearers, modules: Config, basedir: './pluggables'

  # load game components (after pluggable modules, because some components references modules)
  require_dir './game_components', first: %w{layout game_objects}

  # load game states
  require 'game_states/play.rb' # FIXME: revert when all game states are converted to NF

  # The game window
  class Game < NightFury::Window
    include Config
    
    def initialize
      load_config
      super(config[:width] || 500, config[:height] || 500, config[:fullscreen])
      
      push_game_state(Play)
    end
    
    def load_config
    end
  end
end

# Run it
Phitris::Game.new.show
