module Phitris
  class Board < Tetrion
    traits :timer
    include Chingu::Helpers::InputClient
    include Config

    config board_size: [10,20], fixed_tetromino_alpha: 192, tetrion_border: 0xFF443399, tetrion_background: 0xFF8090a0, tetrion_padding: 10, line_clearer: Phitris::LineClearers.all.first

    attr_reader :blocks, :board_size, :origin
    
    def initialize(options = {})
      super(options = config.merge(options))

      self.image = Gosu::Image[Tetromino.config[:image]]
      
      extend options[:line_clearer]
      @board_size = Point.new(*options[:board_size])
      @fixed_tetromino_alpha = options[:fixed_tetromino_alpha]
      @board_offset = Point.new(Tetromino.max_size, Tetromino.max_size)
      @real_board_size = Point.new(@board_size.x+2*@board_offset.x, @board_size.y+2*@board_offset.y)
      @blocks = Array.new(@real_board_size.y) { Array.new(@real_board_size.x, nil) }
      
      @origin = Point.new(x+padding, y+padding)
    end
    
    def fit?(tetromino)
      position = tetromino.position
      tetromino_blocks = tetromino.blocks
      
      # when the tetromino crosses the left board boundary, we have to check if any of the tetromino block is outside the board, if it is we have a non fit.
      return false if position.x < 0 && tetromino_blocks.map {|line| line.slice(0, -position.x)}.flatten.any?
      # the same goes when the tetromino crosses the right board boundary
      return false if position.x+tetromino_blocks.first.size > board_size.x && tetromino_blocks.map {|line| line.slice(board_size.x-position.x, line.size)}.flatten.any?
      # the same goes when the tetromino crosses the bottom board boundary
      return false if position.y+tetromino_blocks.size > board_size.y && tetromino_blocks[board_size.y-position.y, blocks.size].flatten.any?
      
      # Now check: if any block that is present on the board and in the tetromino, then we have a collision
      !tetromino_blocks.each_with_index.find {|tetromino_line, delta_y| tetromino_line.zip(blocks[position.y+delta_y+@board_offset.y][position.x+@board_offset.x..-1]).find {|pair| pair.first && pair.last} }
    end

    def fix(tetromino, options = {})
      tetromino.blocks.each_with_index do |tetromino_line, delta_y|
        blocks[tetromino.position.y+delta_y+@board_offset.y][tetromino.position.x+@board_offset.x,tetromino_line.size] = tetromino_line.zip(blocks[tetromino.position.y+delta_y+@board_offset.y][tetromino.position.x+@board_offset.x,tetromino_line.size]).map {|line| line.compact.first.tap {|color| color.alpha = @fixed_tetromino_alpha if color } }
      end
      
      collapse(options)
    end

    def collapse(options = {})
      unless (indexes = complete_lines).empty?
        age, duration = 0, (options[:fall_delay] || 100) / 2
        during(duration) do
          # fade color of indexes lines to white
          age += $window.milliseconds_since_last_tick
          t = [age.to_f / duration, 1.0].min
          indexes.each {|index| @blocks[index].map! {|block| block && block.class.from_hsv(block.hue, 1.0-t, block.value) } }
        end.then do
          remove_complete_lines
          game_state.reward(:collapse, indexes.size)
          game_state.reward(:bravo) if empty?
          
          collapse
        end
      end
    end
    
    def empty?
      !@blocks.flatten.any?
    end
    
    def draw
      super
      @blocks[@board_offset.y...-@board_offset.y].each_with_index do |line, pos_y|
        line[@board_offset.x...-@board_offset.x].each_with_index do |block, pos_x|
          next unless block
          self.color = block
          draw_relative(padding+pos_x*image.width, padding+pos_y*image.height)
        end
      end
    end
    
    def inside_width
      @inside_width ||= board_size.x*image.width
    end
    
    def inside_height
      @inside_height ||= board_size.y*image.height
    end
    
  end
end
