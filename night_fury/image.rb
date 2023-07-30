module NightFury
  class Image
    attr_reader :width, :height, :path
    def initialize(path)
      @path = path
      @width, @height = $gtk.calcspritebox(@path)
    end
  end
end
