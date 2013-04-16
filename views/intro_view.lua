

IntroView = class("IntroView", View)

function IntroView:drawContent()
  love.graphics.setFont(game.fonts.regular)
  local c = 255 * math.min(1, (self.dt_timer/3))
  love.graphics.setColor(c,c,c, c)
end

function IntroView:update(dt)
  if not self.dt_timer then self.dt_timer = 0 end
  self.dt_timer = self.dt_timer + dt
end

