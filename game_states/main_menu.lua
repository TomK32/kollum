require 'views/menu_view'

MainMenu = class("MainMenu", GameState)

function MainMenu:initialize()
  love.audio.play(game.sounds.startmenu) -- stream and loop background music
  self.view = MenuView()
end

function MainMenu:update(dt)
  self.view:update(dt)
end

function MainMenu:draw()
  self.view:draw()
end

function MainMenu:keypressed(key, code)
  if key == 'n' then
    game:start()
  end
  gui.keyboard.pressed(key, code)
end
