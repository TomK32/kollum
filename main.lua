--
-- A game about a Vampire (villain + Day&Night, 2 themes) salvaging (3) an alien ship (outerspace)
-- and working (construction) inside a Nazi fortress (devil) a Chaos (7) Devices to cause the
-- End Of The World (music). You also need to construct something to make a journey (9)
-- to a parallel world (10).
--
require 'lib/middleclass'
require 'lib/AnAL'
require 'lib/astar'
require 'game'
require 'views/view'
require 'views/map_view'
require 'game_states/state'
require 'game_states/intro'
require 'game_states/main_menu'
require 'game_states/map_state'
require 'level'
require 'map'
require 'sound_manager'

fx = {}
fx.bloom_noise = require 'shader/bloom_noise'

function love.load()
  game.animations = require('animations')
  game.sounds = require('sounds')
  setGraphicMode()
  love.audio.play(game.sounds.startmenu) -- stream and loop background music
  game.current_state = Intro(game.newVersionOrStart)
end

function love.draw()
  game.current_state:draw()
end

function love.keypressed(key)
end

function love.update(dt)
  game.current_state:update(dt)
  love.audio.update()
end

function setGraphicMode()
  local modes = love.graphics.getModes()
  table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end)
  local preferred_mode = modes[1]
  for i, mode in ipairs(modes) do
    if math.abs(9/16 - mode.height / mode.width) < 0.1 and (mode.height >= 768 or mode.width >= 1366) then
      preferred_mode = mode
    end
  end
  game:setMode(preferred_mode)
end
