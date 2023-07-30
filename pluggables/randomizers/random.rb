module Phitris
  module Randomizers
    class Random
      include Config

      def self.name
        config[:display_name] || "Random Generator"
      end
      
      def self.instance
        @instance ||= new
      end

      def initialize
        @tetrominos = Tetromino.all
        @bag = []
        prepare
      end
      
      # Return an array of the next tetromino
      def next(count = 1)
        prepare(count)
        @bag.first(count)
      end
      
      # Pick the next tetromino (further accessible with #current)
      def pick
        prepare
        @bag.shift
      end
      
      protected
      
      def prepare(count = 1)
        @bag.concat(@tetrominos.shuffle) while @bag.size <= count
      end
    end
  end
end
