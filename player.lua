
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
  self.game = game
  self.level = level
  self.direction = nil
  self.dt_since_input = 0
  self.entity_type = 'Actor'
  self:setInputs(Player.input_alternatives['arrows'])
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

