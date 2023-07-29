module NightFury
  class Sprite < Object
    def self.create(*options, &block)
      new(*options, &block)
    end
  end
end
