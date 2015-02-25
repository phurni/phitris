module Phitris
  module Rotators
    module SRS
      include Config
      
      def self.display_name
        config[:display_name] || "SRS"
      end

      def self.extend_object(tetromino)
        super
        tetromino.initialize_rotator
      end
      
      SHAPES = {
        'I' => [[ nil, nil, nil, nil],[true,true,true,true],[nil, nil, nil, nil],[nil, nil, nil, nil]],
        'O' => [[ nil,true,true, nil],[ nil,true,true, nil],[nil, nil, nil, nil]],
        'J' => [[true, nil, nil],[true,true,true],[ nil, nil, nil]],
        'L' => [[ nil, nil,true],[true,true,true],[ nil, nil, nil]],
        'S' => [[ nil,true,true],[true,true, nil],[ nil, nil, nil]],
        'Z' => [[true,true, nil],[ nil,true,true],[ nil, nil, nil]],
        'T' => [[ nil,true, nil],[true,true,true],[ nil, nil, nil]]
      }
      
      attr_reader :blocks
      
      def initialize_rotator
        @blocks = SHAPES[name].map {|line| line.map {|item| item ? color : nil}}
      end
      
      def place_on_board
        @position = Point.new(board.board_size.x / 2 -2, -2)
      end
      
      def rotate_right
        rotate { @blocks = @blocks.reverse.transpose }
      end
      
      def rotate_left
        rotate { @blocks = @blocks.transpose.reverse }
      end
      
      protected
      
      def rotate
        # no rotation for the O tetromino
        return if name == 'O'
        
        # regular rotation
        return if try { yield }

        # Apply wall kicks
        return if try { position.x += 1; yield }
        return if try { position.x -= 1; yield }
        
        # special case for the I tetromino
        if name == 'I'
          return if try { position.x += 2; yield }
          return if try { position.x -= 2; yield }
        end
      end
      
      def try(&block)
        current_blocks = @blocks
        @blocks = current_blocks unless success = super(&block)
        success
      end
      
    end
  end
end