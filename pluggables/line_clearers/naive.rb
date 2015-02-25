module Phitris
  module LineClearers
    module Naive
      include Config
      
      def self.display_name
        config[:display_name] || "Naive"
      end
      
      def complete_lines
        @blocks.each_with_index.select {|line,index| line[@board_offset.x...-@board_offset.x].all?}.map(&:last)
      end
      
      def remove_complete_lines
        indexes = complete_lines
        indexes.reverse.each {|index| @blocks.delete_at index}
        @blocks.insert(0, *(Array.new(indexes.size) { Array.new(@real_board_size.x,nil) }))
      end
      
    end
  end
end