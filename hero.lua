
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
  self.speed = 0.15 -- every x seconds
  self.score = 0
  self.health = 100
  self.treasureDistance = 10
  self.targetTreasure = nil
end

function Hero:update(dt)

  if self.targetTreasure then
    self.direction = self:directionToTreasure(self.targetTreasure)
  else
    self.targetTreasure = self:findTreasure()
    if self.targetTreasure then
      return true
    end
  end
  if not self.direction then
    self.direction = self:directionToExit()
  end

  self.dt_since_movement = 0

  if self:updatePosition() then
    local tile = self.level.map:getTile(self.position)
    if tile and tile.exit then
      self.score = self.score + 1
    end
    if tile:get('Treasure') and #tile:get('Treasure') > 0 then
      for i, treasure in ipairs(tile:get('Treasure')) do
        for i2, treasure2 in ipairs(self.level.treasures) do
          if treasure == treasure2 then
            table.remove(self.level.treasures, i2)
          end
        end
      end
      tile.entities['Treasure'] = nil
      self.targetTreasure = nil
      self.score = self.score + 1
    end
  end
end

function Hero:findTreasure()
  for i, treasure in ipairs(self.level.treasures) do
    local treasure_path = self.level.astar:findPath(self.position, treasure.position)
    if treasure_path and #treasure_path:getNodes() < self.treasureDistance then
      return treasure
    end
  end
  return false
end

function Hero:directionToTreasure(treasure)
  local path = self.level.astar:findPath(self.position, treasure.position)
  return self:nodeToDirection(path:getNodes()[1])
end
function Hero:directionToExit()
  local path = self.level.astar:findPath(self.position, self.level.exits[1].position)
  if not path then return false end

  local next_node = path:getNodes()[1]
  if not next_node then return false end
  return self:nodeToDirection(next_node)
end

function Hero:nodeToDirection(node)
  return {
    x = node.location.x - self.position.x,
    y = node.location.y - self.position.y }
end
