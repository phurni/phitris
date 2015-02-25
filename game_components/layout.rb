module Phitris
  module Layout
    def layout_column(x, y, *items)
      y_org, max_width = y, 0
      items.map do |item|
        size = case item
        when Array then layout_line(x, y, *item)
        when Hash  then item.first.first.create(self, item.first.last, :x => x, :y => y)
        else;           item.create(:x => x, :y => y)
        end
        y += size.height
        max_width = [max_width, size.width].max
        size
      end.each {|size| size.max_width = max_width if size.respond_to? :max_width=}
      Size.new(max_width, y-y_org)
    end

    def layout_line(x, y, *items)
      x_org, max_height = x, 0
      items.each do |item|
        size = case item
        when Array then layout_column(x, y, *item)
        when Hash  then item.first.first.create(self, item.first.last, :x => x, :y => y)
        else;           item.create(:x => x, :y => y)
        end
        x += size.width
        max_height = [max_height, size.height].max
      end
      Size.new(x-x_org, max_height)
    end
  end
end
