
Hero = class("Hero", Actor)

function Hero:initialize(position, animations, game, level)
  self.position = position
  self.animations = animations
  self.animation = animations.standing
  self.game = game
  self.level = level
  self.direction = false
  self.dt_since_movement = 0
  self.entity_type = 'Actor'
end

function Hero:update(dt)
  if self.dt_since_movement < 1 then
    self.dt_since_movement = self.dt_since_movement + dt
    return false
  end
  self.dt_since_movement = 0
  self.direction = {x = 1-math.floor(math.random()*3), y = 1-math.floor(math.random()*3)}

  self:updatePosition()
end
