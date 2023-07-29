# PHITRIS: A Tetris clone using DragonRuby
# August 2023

require_relative 'lib/require_dir'

# load meta components
require_dir './lib'

# namespace our program, a sane habit
module Phitris
  
  # define and load pluggable modules
  include Plugger
  plug :randomizers, :rotators, :line_clearers, modules: Config, basedir: './pluggables'

  # load game components (after pluggable modules, because some components references modules)
  require_dir './game_components', first: %w{layout game_objects}

  # load game states
  require_dir './game_states'

  # The game window
  class Game < Chingu::Window
    include Config
    
    def initialize
      load_config
      super(config[:width] || 500, config[:height] || 500, config[:fullscreen])
      
      self.caption = config[:caption] || "PHItris"
      push_game_state(Menu)
    end
    
    def load_config
      config YAML.load_file(ARGV[0] || 'phitris.yml')
    rescue Errno::ENOENT
      STDERR.puts "Your config file is missing! #{ARGV[0]}" if ARGV[0]
    rescue
      STDERR.puts "Your config file is mangled! #{$!}"
    end
  end
end

# Run it
Phitris::Game.new.show
