module NightFury
  # Immutable color
  class Color
    # Create color from this method so that we can implement some caching in the future
    def self.from(*args)
      return args.first if args.first.is_a? self.class
      new(*args)
    end

    attr_reader :red, :green, :blue, :alpha
    attr_reader :to_hash

    protected def initialize(*args)
      if args.size == 1
        integer_color = args.first
        @alpha, @red, @green, @blue = (integer_color >> 24), (integer_color >> 16 & 0xFF), (integer_color >> 8 & 0xFF), (integer_color & 0xFF)
      else
        @alpha, @red, @green, @blue = args
      end
      @to_hash = {r: @red, g: @green, b: @blue, a: @alpha}
    end

    # Warning: these constants are declared AFTER the `initialize` method because DR will directly call `new` even before the end of the class declaration.
    BLACK = new(255, 0, 0, 0)
    WHITE = new(255, 255, 255, 255)
  end
end
