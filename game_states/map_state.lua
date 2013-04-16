
require 'actors/actor'
require 'actors/player'

MapState = class("MapState", State)
function MapState:initialize(level)
  self.name = name
  self.level = Level(level, game.seed)
  self.players = self.level.players
  self.view = MapView(self.level.map)
end

function MapState:update(dt)
  for i, player in ipairs(self.players) do
    if player.health <= 0 then
      game:finish(self.players)
    end
  end
  for i, player in ipairs(self.players) do
    player:update(dt)
  end

  self.level.map:update(dt)

  if self.exit_reached then
    self:exitTo(game.exit_reached)
    self.exit_reached = nil
  end
end

function MapState:draw()
  self.view:draw()
  love.graphics.setFont(game.fonts.small)
  love.graphics.print(love.graphics.getCaption() .. ' Seed: ' .. game.seed, 10, love.graphics.getHeight(), 0, 1, 1, 0, 14)
  love.graphics.setFont(game.fonts.regular)
end

