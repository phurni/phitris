module NightFury
  class GameState < Object
    def tick(args)
      args.outputs.debug << args.gtk.framerate_diagnostics_primitives
    end
  end
end
