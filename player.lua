
Player = class("Player", Actor)
Player.input_alternatives = {
  arrows = {
    keyboard = {
      up = 'up',
      down = 'down',
      left = 'left',
      right = 'right',
    }
  }
}
Player.movements = {
  up    = { x = 0, y = - 1 },
  down  = { x = 0, y =   1 },
  left  = { x = - 1, y = 0 },
  right = { x =   1, y = 0 },
}

function Player:initialize(position, animations, game, level)
  self.position = position
  self.animations = animations
  self.animation = animations.standing
  table.insert(game.active_animations, self.animation)
  self.game = game
  self.level = level
  self.direction = nil
  self.dt_since_input = 0
  self.entity_type = 'Actor'
  self:setInputs(Player.input_alternatives['arrows'])
end

function Player:positionUpdated(dt)
  -- hit him hard
  if math.abs(game.hero.position.x - self.position.x) < 2 and
    math.abs(game.hero.position.y - self.position.y) < 2 then
    game:heroHit()
  end
  local tile = self.level.map:getTile(self.position)
  if tile:get('Treasure') and #tile:get('Treasure') > 0 then
    for i, treasure in ipairs(tile:get('Treasure')) do
      for i2, treasure2 in ipairs(self.level.treasures) do
        if treasure == treasure2 then
          table.remove(self.level.treasures, i2)
        end
      end
    end
    game.hero.targetTreasure = nil
    love.audio.play(game.sounds.pickup_coin)
    tile.entities['Treasure'] = nil
  end

end

function Player:setInputs(inputs)
  self.inputs = {}
  for direction, key in pairs(inputs.keyboard) do
    self.inputs[key] = Player.movements[direction]
  end
end

function Player:setDistanceToFinish()
  if self.next_waypoint.is_finish and not self.runner.running then
    self.distance_to_finish = 0
    return
  end
  self.distance_to_finish = math.floor(self.next_waypoint.distance_to_finish + self.next_waypoint:distanceTo(self.position))
  if self.closest_to_finish < self.distance_to_finish then
    self.wrong_direction = true
  else
    self.wrong_direction = false
    self.closest_to_finish = self.distance_to_finish
  end
end

