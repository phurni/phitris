module NightFury
  class Timer
    def then(&block)
      @then_block = block
    end

    def destroy!
      @destroyed = true
    end

    def destroyed?
      @destroyed
    end
  end

  class EveryTimer < Timer
    def initialize(duration_ticks, block)
      @block = block
      @duration_ticks = duration_ticks
      @target_tick_count = Kernel.tick_count + @duration_ticks
    end

    def tick(args)
      if args.state.tick_count >= @target_tick_count
        @target_tick_count = Kernel.tick_count + @duration_ticks
        @block.call
      end
    end
  end

  class BetweenTimer < Timer
    def initialize(tick_range, block)
      @block = block
      @tick_range = tick_range
    end

    def tick(args)
      if @tick_range.include? args.state.tick_count
        @block.call
      end
      if args.state.tick_count > @tick_range.end
        @then_block.call if @then_block
        destroy!
      end
    end
  end

  module Timers
    def update(args)
      @_timers ||= []
      @_timers.each {|timer| timer.tick(args) unless timer.destroyed? }
      #super # FIXME: Re-enable when Module.prepend will work (instead of Module.include)
    end

    def every(duration, options = {}, &block)
      @_timers ||= []
      @_timers << EveryTimer.new(duration / 16.6666666666666667, block)
    end

    def during(duration, options = {}, &block)
      @_timers ||= []
      current_tick_count = Kernel.tick_count
      tick_range = current_tick_count..(current_tick_count + (duration / 16.6666666666666667))

      @_timers << BetweenTimer.new(tick_range, block)
    end
  end
end
