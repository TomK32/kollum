--
-- A game about a Vampire (villain + Day&Night, 2 themes) salvaging (3) an alien ship (outerspace)
-- and working (construction) inside a Nazi fortress (devil) a Chaos (7) Devices to cause the
-- End Of The World (music). You also need to construct something to make a journey (9)
-- to a parallel world (10).
--
require 'lib/middleclass'
require 'lib/AnAL'
package.path = './lib/lua-astar/?.lua;' .. package.path
print(package.path)
require 'lib/lua-astar/astar'
require 'views/view'
require 'views/menu'
require 'views/map_view'
require 'level'
require 'map'
require 'sound_manager'

require 'actor'
fx = {}
fx.bloom_noise = require 'shader/bloom_noise'

game = {
  state = 'menu',
  current_level = 0,
  levels = {},
  views = { menu = MenuView() },
  hero_colors = {{200,0,0,255}, {0, 200, 0, 255}},
  graphics = {
    fullscreen = false,
    mode = { height = love.graphics.getHeight(), width = love.graphics.getWidth() }
  },
  map = nil,
  seed = (os.time() % 10) + 100,
  fonts = {
    small = love.graphics.newFont(10),
    regular = love.graphics.newFont(14),
    large = love.graphics.newFont(24)
  },
  actors = {},
  active_animations = {},
  level_dt = 0,
  hit_dt = 0
}

function game:start()
  game.hero = Hero({x=1, y=1}, game.animations.hero, game, self)
  game.villain = Player({x=1, y=1}, game.animations.villain, game, self)
  self:nextLevel()
  self.views.map.display.width = game.graphics.mode.width - 10
  self.views.map.display.height = game.graphics.mode.height - 10
  self.state = 'map'
end

function game:exitTo(exit)
  self:nextLevel(exit.level)
end

function game:nextLevel(level_num)
  self.actors = {}
  local last_seed = self.seed
  if self.levels[self.current_level] then
    last_seed = self.levels[self.current_level].seed
  end
  if not level_num then
    self.current_level = game.current_level + 1
  else
    self.current_level = level_num
  end
  table.insert(self.levels, Level(self.current_level, last_seed + 1))
  game.map = self.levels[self.current_level].map
  if not self.views.map then
    self.views.map = MapView(game.map)
  else
    self.views.map.map = game.map
  end
  table.insert(self.actors, self.villain)
  table.insert(self.actors, self.hero)
  self.level_dt = 1
  love.audio.play(game.sounds.level)
end

function game:setMode(mode)
  game.graphics.mode = mode
  love.graphics.setMode(mode.width, mode.height)
end

function game:heroHit(position)
  self.hero.health = self.hero.health - 5
  self.hit_dt = 1
  game.hit_position = position
  love.audio.play(game.sounds.hit)
end

function love.load()
  game.animations = require('animations')
  table.insert(game.active_animations, game.animations.valve)
  game.sounds = require('sounds')
  love.audio.play(game.sounds.startmenu) -- stream and loop background music
end

function love.draw()
  if game.state == 'menu' then
    drawValve()
    game.views.menu:draw()
  elseif game.state == 'map' then
    game.views.map:draw()
    drawStats()
    drawHit()
    drawLevel()
  elseif game.state == 'finished' then
    drawFinish()
  end
  love.graphics.setFont(game.fonts.small)
  love.graphics.print(love.graphics.getCaption() .. ' Seed: ' .. game.seed, 10, love.graphics.getHeight(), 0, 1, 1, 0, 14)
  love.graphics.setFont(game.fonts.regular)
end

function drawFinish()
  if game.hero.health < 0 then
    text = {'Congratulations, you killed that rotten "hero" Tombo.', 'You got your prescious pressure valve back'}
  end
  if game.hero.score > 100 then
    text = {'Sorry, but you lost and that so called hero Tombo has won'}
  end
  love.graphics.setFont(game.fonts.large)
  love.graphics.setColor(255 - game.hero.score, 255 - game.hero.health, 255 - game.hero.health - game.hero.score)
  for i, line in ipairs(text) do
    love.graphics.print(line, game.graphics.mode.width / 3, game.graphics.mode.height / 3 + 30 * i)
  end
end

function drawLevel()
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

function drawHit()
  if game.hit_dt > 0 then
    love.graphics.push()
    love.graphics.scale(10,10)
    love.graphics.setColor(255,50,50,200)
    love.graphics.print('HIT!',
        math.sin(game.hit_dt) * 30,
        game.graphics.mode.height / 250 * math.sin(game.hit_dt)*10)
    love.graphics.pop()
  end
end

function drawValve()
  love.graphics.push()
  love.graphics.setFont(game.fonts.large)
  love.graphics.setColor(255,255,255,200)
  love.graphics.print('Kollum: The Pressure Valve', 250, 50)
  love.graphics.setColor(255,255, 0, 255)
  love.graphics.print('Kollum: The Pressure Valve', 249, 49)

  local text = {
    'You are Kollum the Destoryer!',
    'Back in the olden days you brought',
    'death upon the ancient',
    'underground city of Ludarume.',
    '',
    'You have only one precious little thing',
    'left in this world: The Pressure Valve',
    'But you lost it close to the surfance',
    'where some adventurer named Tombo found it!',
    '',
    'You want your precious back',
    'and you must stop Tombo in his quest.'
  }

  love.graphics.setFont(game.fonts.regular)
  for i, line in ipairs(text) do
    love.graphics.print(line, 260, 80 + 17 * i)
  end

  love.graphics.scale(20,20)
  game.animations.valve:draw(game.graphics.mode.width / 45, game.graphics.mode.height / 50)
  love.graphics.pop()
end

function drawStats()
  love.graphics.push()
  for i, actor in ipairs(game.actors) do
    if actor.class.name == 'Hero' then
      love.graphics.setFont(game.fonts.regular)
      love.graphics.translate(game.graphics.mode.width - 300, i * 20)
      love.graphics.setColor(unpack(game.hero_colors[(i % #game.hero_colors)+1]))
      love.graphics.print('Hero score: ' .. actor.score .. ' / Health: ' .. actor.health, 0, 0)
    end
  end
  love.graphics.pop()
end

function love.keypressed(key)
end

function love.update(dt)
  if game.exit_reached then
    game:exitTo(game.exit_reached)
    game.exit_reached = nil
  end

  love.audio.update()

  if game.level_dt > 0 then
    game.level_dt = game.level_dt - dt
  end
  if game.hit_dt > 0 then
    game.hit_dt = game.hit_dt - dt
  end

  if game.state == 'menu' then
    game.views.menu:update(dt)
    game.animations.valve.running = true
  elseif game.state == 'map' then
    if game.hero.health < 0 or game.hero.score > 20 then
      game.state = 'finished'
      return
    end

    if game.villain:update(dt) then
      -- only move hero if vaillain moved
      game.hero:update(dt)
    end
    game.views.map:update(dt)
    game.animations.valve.running = false
  end
  for i, animation in ipairs(game.active_animations) do
    animation:update(dt)
  end
end

