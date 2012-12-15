--
-- A game about a Vampire (villain + Day&Night, 2 themes) salvaging (3) an alien ship (outerspace)
-- and working (construction) inside a Nazi fortress (devil) a Chaos (7) Devices to cause the
-- End Of The World (music). You also need to construct something to make a journey (9)
-- to a parallel world (10).
--

require 'lib/middleclass'
require 'lib/AnAL'
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
  graphics = {
    fullscreen = false,
    mode = { height = love.graphics.getHeight(), width = love.graphics.getWidth() }
  },
  map = nil,
  seed = (os.time() % 10) + 100,
  fonts = {
    small = love.graphics.newFont(10),
    regular = love.graphics.newFont(14)
  },
  actors = {}
}

function game:start()
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
  if not level_num then
    self.current_level = game.current_level + 1
  else
    self.current_level = self.level_num
  end
  table.insert(self.levels, Level(self.current_level, self.seed))
  game.map = self.levels[self.current_level].map
  self.views.map = MapView(game.map)
end

function game:setMode(mode)
  game.graphics.mode = mode
  love.graphics.setMode(mode.width, mode.height)
end

function love.load()
  game.animations = require('animations')
  game.sounds = require('sounds')
  love.audio.play(game.sounds.startmenu) -- stream and loop background music

  game:start()
end

function love.draw()
  if game.state == 'menu' then
    drawValve()
    game.views.menu:draw()
  elseif game.state == 'map' then
    love.graphics.setPixelEffect(fx.bloom_noise)
    game.views.map:draw()
    love.graphics.setPixelEffect()
  end
  love.graphics.setFont(game.fonts.small)
  love.graphics.print(love.graphics.getCaption() .. ' Seed: ' .. game.seed, 10, love.graphics.getHeight(), 0, 1, 1, 0, 14)
  love.graphics.setFont(game.fonts.regular)
end

function drawValve()
  love.graphics.push()
  love.graphics.scale(20,20)
  game.animations.valve:draw(game.graphics.mode.width / 45, game.graphics.mode.height / 50)
  love.graphics.pop()
end

function love.keypressed(key)
end

function love.update(dt)
  love.audio.update()
  if game.state == 'menu' then
    game.views.menu:update(dt)
    game.animations.valve.running = true
  elseif game.state == 'map' then
    for i, actor in ipairs(game.actors) do
      actor:update(dt)
    end
    game.views.map:update(dt)
    game.animations.valve.running = false
  end
  for i, animation in pairs(game.animations) do
    if animation.running then
      animation:update(dt)
    end
  end
end

