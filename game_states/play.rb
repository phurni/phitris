module Phitris
  class Play < NightFury::GameState
    #TODO: trait :timer
    include Config
    include Layout
    
    config margin: 20, captions: {'hold' => 'Hold', 'next' => 'Next', 'level' => 'Level', 'score' => 'Score', 'lines' => 'Lines', 'time' => 'Time'}, tetrion_background: 0xFF001133, initial_fall_delay: 500, max_level: 20,
      rewards: {nil => 0, soft_drop: 1, hard_drop: 2, collapse1: 100, collapse2: 300, collapse3: 500, collapse4: 800, bravo: 200 },
      layout: [
        Margin,
        [Margin, {Caption => :hold}, HoldTetromino, Margin, {Caption => :score}, Score, Margin, {Caption => :lines}, Lines, Margin, {Caption => :time}, ElapsedTime, Margin],
        Margin,
        [Margin, [{Caption => :level}, Level], Board, Margin],
        Margin,
        [Margin, {Caption => :next}, NextTetrominos, Margin]
      ]
    
    
    class WindowTetrion < Tetrion
      def inside_width
        $window.width - padding*2
      end

      def inside_height
        $window.height - padding*2
      end
    end
    
    def initialize
      super
      #TODO: self.input = { :p => Chingu::GameStates::Pause, [:q, :escape] => :pop_game_state, :h => :hold }
      
      # Create the window tetrion
      WindowTetrion.create(config)

      # Layout our game objects
      layout_line(0, 0, *config[:layout])
      
      # find the Board and the HoldTetromino from all the created objects
      @board = game_objects.select {|obj| obj.is_a? Board}.first
      @hold = game_objects.select {|obj| obj.is_a? HoldTetromino}.first
      
      # Init the game values
      Lines.value = 0
      Score.value = 0
      Level.value = 1
      ElapsedTime.value = 0

      @initial_fall_delay = config[:initial_fall_delay]
      @max_level = config[:max_level]
      
      @fall_delay = @initial_fall_delay
      place_new_tetromino
    end
    
    def place_new_tetromino(tetromino_class = nil)
      @current_tetromino = (tetromino_class || Tetromino.config[:randomizer].instance.pick).create(:board => @board)
      @current_tetromino.put_on_board_and_fall_at(@fall_delay)
      # Does it fit on the board?
      if @current_tetromino.fit?
        # Yep, tie the input controls
        #TODO: @current_tetromino.input = { :left => :shift_left, :right => :shift_right, :down => :soft_drop, :up => :hard_drop, :space => :rotate_right, :m => :rotate_right, :n => :rotate_left }
      else
        # Nope, game over!
        #TODO: push_game_state GameOver
      end
      
      @held = false
      NextTetrominos.shift
    end
    
    def hold
      unless @held
        held_tetromino = @hold.tetromino
        @hold.tetromino = @current_tetromino.class.new
        @current_tetromino.destroy!
        place_new_tetromino(held_tetromino && held_tetromino.class)
        @held = true
      end
    end
    
    def reward(action, data = nil)
      case action
      when :collapse
        Score.value += config[:rewards][:"collapse#{data}"] * Level.value
        Lines.value += data
      when :hard_drop
        Score.value += config[:rewards][action]*data
      else
        Score.value += config[:rewards][action]
      end
      
      Level.value = (Lines.value / 10) + 1
      @fall_delay = @initial_fall_delay-@initial_fall_delay/(@max_level/Level.value.to_f)
    end
    
  end
end