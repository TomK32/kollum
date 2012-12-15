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
require 'map'
require 'sound_manager'

fx = {}
fx.bloom_noise = require 'shader/bloom_noise'

game = {
  state = 'menu',
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
  }
}

function game:start()
  SimplexNoise.seedP(game.seed)
  self.map = Map(100, 100)
  self.views.map = MapView(self.map)
  self.views.map.display.width = game.graphics.mode.width - 10
  self.views.map.display.height = game.graphics.mode.height - 10
  self.state = 'map'
end

function game:setMode(mode)
  game.graphics.mode = mode
  love.graphics.setMode(mode.width, mode.height)
end

function love.load()
  game.animations = require('animations')
  game.sounds = require('sounds')
  love.audio.play(game.sounds.startmenu) -- stream and loop background music
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
    game.views.map:update(dt)
    game.animations.valve.running = false
  end
  for i, animation in pairs(game.animations) do
    if animation.running then
      animation:update(dt)
    end
  end
end

--game:start()