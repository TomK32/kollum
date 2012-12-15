
gui = require 'lib/quickie'

MenuView = class("MenuView", View)

MenuView.mode = {fullscreen = false }

gui.core.style.color.normal.bg = {80,180,80}

function MenuView:draw()
  gui.core.draw()
end

function MenuView:update(dt)
  gui.group.push({grow = "down", pos = {100, 150}})
  -- start the game
  if gui.Button({text = 'Start'}) then
    game:start()
  end

  -- screen resolutions
  gui.group.push({grow = "down", pos = {0, 20}})
  modes = love.graphics.getModes()
  table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)   -- sort from smallest to largest
  for i, mode in ipairs(modes) do
    if gui.Button({text = mode.width .. 'x' .. mode.height}) then
      game:setMode(mode)
    end
  end

  -- fullscreen toggle
  if self.mode.fullscreen then
    text = 'Windowed'
  else
    text = 'Fullscreen'
  end
  if gui.Button({text = text}) then
    game.graphics.fullscreen = not game.graphics.fullscreen
    love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), game.graphics.fullscreen)
  end
end
