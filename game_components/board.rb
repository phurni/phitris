module Phitris
  class Board < Tetrion
    include NightFury::Timers
    #TODO: include Chingu::Helpers::InputClient
    include Config

    config board_size: [10,20], fixed_tetromino_alpha: 192, tetrion_border: 0xFF443399, tetrion_background: 0xFF8090a0, tetrion_padding: 10, line_clearer: Phitris::LineClearers.all.first

    attr_reader :lines, :board_size, :origin
    
    def initialize(options = {})
      super(options = config.merge(options))

      self.image = NightFury::Image.from(Tetromino.config[:image])
      
      extend options[:line_clearer]
      @board_size = Point.new(*options[:board_size])
      @fixed_tetromino_alpha = options[:fixed_tetromino_alpha]
      @lines = Lines.new(@board_size)
      
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
      return false if position.y+tetromino_blocks.size > board_size.y && tetromino_blocks[board_size.y-position.y, board_size.y].flatten.any?
      
      # Now check: if any block that is present on the board and in the tetromino, then we have a collision
      !tetromino_blocks.each_with_index.find {|tetromino_line, delta_y| tetromino_line.zip(lines[position.y+delta_y][position.x..-1]).find {|pair| pair.first && pair.last} }
    end

    def fix(tetromino)
      tetromino.blocks.each_with_index do |tetromino_line, delta_y|
        lines[tetromino.position.y+delta_y][tetromino.position.x,tetromino_line.size] = tetromino_line.zip(lines[tetromino.position.y+delta_y][tetromino.position.x,tetromino_line.size]).map {|line| (color = line.compact.first) ? color.with(a: @fixed_tetromino_alpha) : color }
      end
    end

    def collapse(options = {})
      unless (indexes = complete_lines).empty?
        age, duration = 0, (options[:fall_delay] || 100) / 2
        during(duration) do
          # fade color of indexes lines to transparent
          age += 16.6666666666666667 # args.state.milliseconds_since_last_tick
          t = [age.to_f / duration, 1.0].min
          indexes.each {|index| lines[index].map! {|block| block && block.with(a: @fixed_tetromino_alpha-(t*@fixed_tetromino_alpha).to_i) } }
        end.then do
          remove_lines_at(indexes)
          game_state.reward(:collapse, indexes.size)
          game_state.reward(:bravo) if empty?
          
          collapse(options)
        end
      end
    end

    def complete_lines
      lines.each_with_index.select {|line,index| line.all?}.map(&:last)
    end
    
    def empty?
      !lines.any? {|line| line.any?}
    end
    
    def draw(args)
      super
      lines.each_with_index do |line, pos_y|
        line.each_with_index do |block, pos_x|
          next unless block
          self.color = block
          args.outputs.sprites << [*to_draw_rect(x+padding+pos_x*image.width, y+padding+pos_y*image.height, image.width, image.height), image.path, 0, *color.to_a]
        end
      end
    end
    
    def inside_width
      @inside_width ||= board_size.x*image.width
    end
    
    def inside_height
      @inside_height ||= board_size.y*image.height
    end
    
    class BoundedArray
      def initialize(size, offset, initial_value = nil, &block)
        @size, @offset = size, offset
        @blocks = block.nil? ? Array.new(size+2*offset, initial_value) : Array.new(size+2*offset, &block)
      end
      
      def [](*args)
        @blocks.send(:[], *coerce_args(args))
      end

      def []=(*args)
        @blocks.send(:[]=, *coerce_args(args))
      end
      
      def each(&block)
        @blocks[@offset...-@offset].each(&block)
        self
      end
      
      def map!(&block)
        @offset.upto(@size+@offset) {|index| @blocks[index] = block.call(@blocks[index]) }
        nil
      end
      
      include Enumerable
      
      protected
      
      def coerce_args(args)
        first_arg = args.first
        if first_arg.is_a? Range
          args[0] = Range.new(first_arg.begin+@offset, first_arg.end < 0 ? first_arg.end-@offset : first_arg.end+@offset, first_arg.exclude_end?)
        else
          args[0] += @offset
        end
        args
      end
    end
    
    class Line < BoundedArray
    end
    
    class Lines < BoundedArray
      def initialize(size)
        @board_size = size
        @board_offset = Point.new(Tetromino.max_size, Tetromino.max_size)
        super(@board_size.y, @board_offset.y) { Line.new(@board_size.x, @board_offset.x) }
      end
      
      def remove_at_indices(indices)
        indices.sort {|x,y| y <=> x}.each {|index| @blocks.delete_at index+@offset}
        @blocks.insert(0, *(Array.new(indices.size) { Line.new(@board_size.x, @board_offset.x) }))
      end
    end
    
  end
end
