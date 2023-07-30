module NightFury
  class Image
    # Create image from this method so that we can implement some caching in the future
    def self.from(object)
      return object if object.is_a? self.class
      new(object)
    end

    attr_reader :width, :height, :path

    protected def initialize(path)
      @path = path
      @width, @height = $gtk.calcspritebox(@path)
    end
  end
end
