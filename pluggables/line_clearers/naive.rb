module Phitris
  module LineClearers
    module Naive
      include Config
      
      def self.display_name
        config[:display_name] || "Naive"
      end

      def remove_lines_at(indexes)
        lines.remove_at_indices indexes
      end
      
    end
  end
end