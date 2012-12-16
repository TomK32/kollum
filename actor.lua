Actor = class("Actor")

require 'player'
require 'hero'

function Actor:move(direction)
  self.direction = direction
end

function Actor:keydown(dt)
  if self.dt_since_input > 0.1 then
    local movement = {x = 0, y = 0}
    local moved = false
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        self.dt_since_input = 0
        moved = true
        movement.x = movement.x + m.x
        movement.y = movement.y + m.y
      end
    end
    if moved then
      self:move(movement)
    end
  end
  self.dt_since_input = self.dt_since_input + dt
end

function Actor:update(dt)
  if self.inputs then
    self:keydown(dt)
  end
  self:updatePosition(dt)
end

function Actor:updatePosition(dt)
  if not self.direction then
    return false
  end

  local old_position = {x = self.position.x, y = self.position.y}

  self.position.x = self.position.x + self.direction.x
  self.position.y = self.position.y + self.direction.y
  local tile = self.game.map:getTile(self.position)
  if not tile or not tile.passable then
    self.position = old_position
    return false
  end
  self.game.map:fitIntoMap(self.position)

  self.game.map:moveEntity(self, old_position, self.position)

  if tile.exit then
    self.game:exitTo(tile.exit)
  end

  if self.inputs then
    --self.game.views.map:centerAt(self.position)
  end

  self.direction = nil
  return true
end

function Actor:finishReached()
  self.game.paused = true
  self.game.ended = true
  love.draw = finishScreen
end

