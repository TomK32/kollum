FinishScreen = class("MainMenu", GameState)

function FinishScreen:load(text)
  love.audio.play(game.sounds.startmenu) -- stream and loop background music
  self.text = text
end

function FinishScreen:draw()
  love.graphics.setFont(game.fonts.large)
  love.graphics.setColor(255 - game.hero.score, 255 - game.hero.health, 255 - game.hero.health - game.hero.score)
  for i, line in ipairs(self.text) do
    love.graphics.print(line, game.graphics.mode.width / 3, game.graphics.mode.height / 3 + 30 * i)
  end
end

