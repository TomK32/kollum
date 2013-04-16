
game = {
  title = 'Kollum',
  debug = false,
  graphics = {
    mode = { height = love.graphics.getHeight(), width = love.graphics.getWidth() }
  },
  fonts = {},
  renderer = require('renderers/default'),
  sounds = require('sounds'),
  animations = require('animations'),
  active_animations = {},
  tile_size = {x = 48, y = 48},
  version = require('version'),
  url = 'http://ananasblau.com/kollum',
  current_level = 1,
  current_state = nil
}

function game:createFonts(offset)
  local font_file = 'fonts/Comfortaa-Regular.ttf'
  self.fonts = {
    lineHeight = (11 + offset) * 1.7,
    small = love.graphics.newFont(font_file, 11 + offset),
    regular = love.graphics.newFont(font_file, 13 + offset),
    large = love.graphics.newFont(font_file, 16 + offset),
    very_large = love.graphics.newFont(font_file, 20 + offset)
  }
end

function game:setMode(mode)
  self.graphics.mode = mode
  love.graphics.setMode(mode.width, mode.height, mode.fullscreen or self.graphics.fullscreen)
  if self.graphics.mode.height < 600 then
    self:createFonts(-2)
  else
    self:createFonts(0)
  end
end


function game:startMenu()
  love.mouse.setVisible(true)
  game.current_state = MainMenu()
end

function game:start()
  game.stopped = false
  love.mouse.setVisible(false)
  game.current_state = MapState(game.current_level)
end

function game:hasNextLevel()
  return true
end

function game:nextLevel()
  if self:hasNextLevel() then
    self.current_level = self.current_level + 1
  end
  game:start()
end

function game:finished(player, message, progress)
  love.mouse.setVisible(true)
  game.stopped = true
  game.current_state = FinishScreen(player, message, progress)
end
function game:killed(player)
  game:finished(player, _('You have lost :('), false)
end

function game.loadImage(image)
  return love.graphics.newImage(image)
end

function game:newVersionOrStart()
  if version and version.version and version.url then
    game:newVersion(version.version, version.url)
  else
    game:startMenu()
  end
end

function game:newVersion(version, url)
  game.current_state = NewVersion(version, url)
end

function game:showCredits()
  game.current_state = State(self, 'Credits', CreditsView())
end

