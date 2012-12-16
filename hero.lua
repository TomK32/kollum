
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
  self.speed = 0.5 -- every x seconds
  self.score = 0
end

function Hero:update(dt)

  if self.dt_since_movement < self.speed then
    self.dt_since_movement = self.dt_since_movement + dt
    return false
  end
  self.path = self.level.astar:findPath(self.position, self.level.exits[1].position)
  print(#self.path:getNodes()[1])
  self.dt_since_movement = 0
  local next_node = self.path:getNodes()[1]

  self.direction = {
    x = next_node.location.x - self.position.x,
    y = next_node.location.y - self.position.y }

  if self:updatePosition() then
    local tile = self.level.map:getTile(self.position)
    if tile and tile.exit then
      self.score = self.score + 1
    end
    if tile:get('Treasure') and #tile:get('Treasure') > 0 then
      self.score = self.score + 1
    end
  end
end
