module Phitris
  module LineClearers
    module Sticky
      include Config
      
      def self.display_name
        config[:display_name] || "Sticky"
      end

      def remove_lines_at(indexes)
        lines.remove_at_indices indexes
        
        # Look for orphan segments above the first complete line (after the remove)
        segments = extract_segments_above(indexes.first+indexes.size)
        
        # Drop and fix all segments
        segments.each do |segment|
          segment.drop
          fix(segment)
        end
      end
      
      protected
      
      def extract_segments_above(max_line_index)
        search_lines = lines[0...max_line_index]
        filled = []
        
        flood_fill = lambda do |line_index, column_index|
          color = search_lines[line_index][column_index]
          return [] if color.nil? || filled.include?([line_index, column_index])
          
          filled << [line_index, column_index]
          segments = [ [line_index, column_index, color ] ]
          
          segments.concat( flood_fill.call(line_index, [0, column_index-1].max) )
          segments.concat( flood_fill.call(line_index, [column_index+1, board_size.x-1].min) )
          segments.concat( flood_fill.call(line_index+1, column_index) ) if line_index+1 < max_line_index
          
          segments
        end
        
        segments = search_lines.each_with_index.flat_map do |line, line_index|
          line.each_with_index.map do |color, column_index|
            flood_fill.call(line_index, column_index)
          end
        end

        # Now, remove board block matching these segments
        filled.each {|line_index, column_index| lines[line_index][column_index] = nil }
        
        segments.reject(&:empty?).map {|segment| SegmentTetromino.new(self, segment) }
      end
      
      class SegmentTetromino
        attr_reader :blocks
        attr_reader :position
        
        def initialize(board, data)
          @board = board

          line_indexes = data.map {|line_index, _, _| line_index }
          line_origin = line_indexes.min
          height = line_indexes.max-line_origin+1
          
          column_indexes = data.map {|_, column_index, _| column_index }
          column_origin = column_indexes.min
          width = column_indexes.max-column_origin+1
          
          @position = Point.new(column_origin, line_origin)
          @blocks = Array.new(height) { Array.new(width) }
          data.each {|line_index, column_index, color| @blocks[line_index-line_origin][column_index-column_origin] = color }
        end
        
        def drop
          @position.y += 1 while @board.fit?(self)
          @position.y -= 1
        end
      end
      
    end
  end
end
