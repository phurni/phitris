module NightFury
  # Immutable color
  class Color
    # Create color from this method so that we can implement some caching in the future
    def self.from(*args)
      return args.first if args.first.is_a? self
      new(*args)
    end

    attr_reader :red, :green, :blue, :alpha
    attr_reader :to_h, :to_a

    protected def initialize(*args)
      if args.size == 1
        color = args.first
        if color.is_a? Integer
          @alpha, @red, @green, @blue = (color >> 24), (color >> 16 & 0xFF), (color >> 8 & 0xFF), (color & 0xFF)
        elsif color.is_a? Hash # we should use `respond_to? :to_hash` but we can't because of some DR object implemeting to_hash instead of to_h
          @alpha, @red, @green, @blue = color.values_at(:a, :r, :g, :b)
        else
          raise ArgumentError.new("Unknown source object #{color} for conversion to NightFury::Color")
        end
      else
        @alpha, @red, @green, @blue = args
      end
      @to_h = {r: @red, g: @green, b: @blue, a: @alpha}
      @to_a = [@alpha, @red, @green, @blue]
    end

    # Create a copy of this color with changes passed as a hash
    # (like https://docs.ruby-lang.org/en/3.2/Data.html#method-i-with)
    def with(**kwargs)
      self.class.new(@to_h.merge(kwargs))
    end

    # Warning: these constants are declared AFTER the `initialize` method because DR will directly call `new` even before the end of the class declaration.
    BLACK = new(255, 0, 0, 0)
    WHITE = new(255, 255, 255, 255)
  end
end
