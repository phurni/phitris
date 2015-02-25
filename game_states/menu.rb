module Phitris
  class Menu < Chingu::GameState
    def initialize
      super
      Chingu::Text.create(:text => "Press space to\n begin playing", :size => 40, :align => :center, :rotation_center => :center_center, :x => $window.width/2, :y => $window.height/2)
      self.input = { :space => Play, [:q, :escape] => :exit }
    end
  end
end
