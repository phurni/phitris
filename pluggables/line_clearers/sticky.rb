module Phitris
  module LineClearers
    module Sticky
      include Config
      
      def self.display_name
        config[:display_name] || "Sticky"
      end

      def remove_lines_at(indexes)
        lines.remove_at_indices indexes
      end
      
    end
  end
end
