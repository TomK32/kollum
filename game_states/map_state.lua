
MapState = class("MapState", State)
function MapState:initialize(game, name)
  self.name = name
  self.game = game
end

function MapState:update(dt)
  if game.hero.health < 0 or game.hero.score > 20 then
    game.state = 'finished'
    return
  end

  if game.villain:update(dt) then
    -- only move hero if vaillain moved
    game.hero:update(dt)
  end

  self.level.map:update(dt)

  if self.exit_reached then
    self:exitTo(game.exit_reached)
    self.exit_reached = nil
  end
  if self.level_dt > 0 then
    self.level_dt = self.level_dt - dt
  end
  local valid_hits = {}
  for i=1, #self.hits do
    if self.hits[i].dt > 0 then
      self.hits[i].dt = self.hits[i].dt - dt
      table.insert(valid_hits, self.hits[i])
    end
  end
  self.hits = valid_hits
end

function MapState:draw()
  self.view:draw()
  self:drawStats()
  self:drawHits()
  self:drawLevel()
  love.graphics.setFont(game.fonts.small)
  love.graphics.print(love.graphics.getCaption() .. ' Seed: ' .. game.seed, 10, love.graphics.getHeight(), 0, 1, 1, 0, 14)
  love.graphics.setFont(game.fonts.regular)
end

function MapState:drawLevel()
  love.graphics.setFont(game.fonts.regular)
  if game.level_dt > 0 then
    love.graphics.push()
    love.graphics.setFont(game.fonts.large)
    love.graphics.setColor(255,255,255,150)
    local d = 1-game.level_dt
    love.graphics.scale(10 * d,10 * d)
    love.graphics.print("Level " .. game.current_level, math.sin(d*3) * 20, 12)
    love.graphics.pop()
  end
end

function MapState:drawStats()
  love.graphics.push()
  for i, actor in ipairs(game.actors) do
    if actor.class.name == 'Hero' then
      love.graphics.setFont(game.fonts.regular)
      love.graphics.translate(game.graphics.mode.width - 200, i * 20)
      love.graphics.setColor(100,100,100,100)
      love.graphics.rectangle('fill', 0, 0, 135, 35)
      love.graphics.setColor(unpack(game.hero_colors[(i % #game.hero_colors)+1]))
      love.graphics.print('Hero score: ' .. actor.score .. '/20', 3, 0)
      love.graphics.print('Health: ' .. actor.health .. '/100', 3, game.fonts.lineHeight)
    end
  end
  love.graphics.pop()
end

function MapState:drawHits()
  for i=1, #game.hits do
    local dt = game.hits[i].dt
    local position = game.hits[i].position
    if dt > 0 then
      love.graphics.push()
      love.graphics.setFont(game.fonts.very_large)
      love.graphics.setColor(255,50,50,200)
      love.graphics.print(game.hits[i].message,
          dt * position.x * game.views.map.tile_size.x,
          dt * position.y * game.views.map.tile_size.y)
      love.graphics.pop()
    end
  end
end

