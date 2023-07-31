module NightFury
  class GameState
    attr_reader :game_objects

    def initialize(options = {})
      super
      @game_objects = []

      $current_state = self
    end

    def tick(args)
      setup(args) if args.state.tick_count == 0
      update(args)
      draw(args)

      args.outputs.debug << args.gtk.framerate_diagnostics_primitives
    end

    def add_game_object(object)
      @game_objects << object
    end

    def remove_game_object(object)
      @game_objects.delete(object)
    end

    def push_game_state(state)
      state.new
    end

    def pop_game_state
      $gtk.request_quit
    end

    protected

    def setup(args)
      @game_objects.each {|object| object.setup(args) }
    end

    def update(args)
      @game_objects.each {|object| object.update(args) }
    end

    def draw(args)
      @game_objects.each {|object| object.draw(args) }
    end

    # Warning: `include` is at the end of the class definition because DR directly calls it and when placed at the start the rest of the class like methods are not yet declared
    include Inputs
  end
end
