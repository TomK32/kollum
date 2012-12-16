
gui = require 'lib/quickie'

MenuView = class("MenuView", View)

MenuView.mode = {fullscreen = false }

gui.core.style.color.normal.bg = {80,180,80}

function MenuView:draw()
  gui.core.draw()

  love.graphics.push()
  love.graphics.setFont(game.fonts.large)
  love.graphics.setColor(255,255,255,200)
  love.graphics.print('Kollum: The Pressure Valve', 250, 50)
  love.graphics.setColor(255,200, 10, 255)
  love.graphics.print('Kollum: The Pressure Valve', 249, 49)

  local text = {
    'You are Kollum the Destroyer!',
    'Back in ye olden days you hath brought',
    'Death upon the ancient',
    'underground Cite of Ludarume.',
    '',
    'You have but one precious little thing',
    'left in this dark world: The Pressure Valve',
    '',
    'But you lost your precious, near the Surfance,',
    'where some adventurer by the name of Tombo found it.',
    '',
    'You want your precious back',
    'and you must stop Tombo in his quest.'
  }
  local y = 80
  love.graphics.setFont(game.fonts.regular)
  for i, line in ipairs(text) do
    y = y + 17
    love.graphics.print(line, 260, y)
  end

  y = y + 40
  love.graphics.setFont(game.fonts.large)
  love.graphics.print('How to play', 250, y)
  text = {
    'Move around with the arrow keys,',
    'Collect the small, useless things that',
    'Tombo wants before he gets to them',
    'Hit him if you must, but he iss strong!',
    'And lastly, get to the exit to the next',
    'level before Tombo does',
    '',
    'You must stop this greedy wanna-be hero!'
  }

  y = y + 20
  love.graphics.setFont(game.fonts.regular)
  for i, line in ipairs(text) do
    y = y + 17
    love.graphics.print(line, 260, y)
  end


  love.graphics.scale(20,20)
  game.animations.valve:draw(game.graphics.mode.width / 45, game.graphics.mode.height / 50)
  love.graphics.pop()

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
