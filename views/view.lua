
View = class("View")
View:include({
  display = {x = 0, y = 0, width = 200, height = 100},
  focus = nil,

  draw = function(self, ...)
    love.graphics.push()
    love.graphics.translate(self.display.x, self.display.y)
    self:drawContent(...)
    love.graphics.pop()
  end
})

function View:setDisplay(display)
  self.display = display
  if display.align then
    if display.align.x == 'center' then
      display.x = love.graphics.getWidth() / 2 - display.width / 2
    end
    if display.align.y == 'center' then
      display.y = love.graphics.getHeight() / 2 - display.height / 2
    end
  end
end

