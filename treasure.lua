Treasure = class("Treasure")

function Treasure:initialize(position, animation, level)
  self.position = position
  self.animation = animation
  self.level = level
  table.insert(game.active_animations, self.animation)
end
