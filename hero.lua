
Hero = class("Hero", Actor)

function Hero:initialize(position, animations, game, level)
  self.position = position
  self.animations = animations
  self.animation = animations.standing
  self.game = game
  self.level = level
  self.direction = nil
  self.dt_since_input = 0
  self.entity_type = 'Actor'
end

