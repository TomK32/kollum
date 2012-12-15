
MapView = class("MapView", View)
MapView:include({
  map = nil,
  tile_size = {x = 24, y = 24},
  cursor_position = { x = 14, y = 11 },
  top_left = { x = 0, y = 0 }, -- offset
  draw_cursor = false,
  canvas = nil,
  arrows = {
    up = { p = function(self) return {-self.tile_size.x, 10, self.tile_size.x, 10, 0, 0} end, t = {1, 0}},
    down = { p = function(self) return {-self.tile_size.x, -20, self.tile_size.x, -20, 0, -10} end, t = {1, 2}},
    right = { p = function(self) return {-20, -self.tile_size.y, -20, self.tile_size.y, -10, 0} end, t = {2, 1}},
    left = { p = function(self) return {10, -self.tile_size.y, 10, self.tile_size.y, 0, 0} end, t = {0, 1}},
  },
  initialize = function(self, map)
    self.map = map
    self.display = {x = 10, y = 10, width = 320, height = 320}
    self.draw_cursor = false
    self.canvas = love.graphics.newCanvas()
    self:update()
  end,

  currentTile = function(self)
    return self.map:getTile(self.cursor_position)
  end,

  drawContent = function(self)
    if self.canvas then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(self.canvas, 0, 0)
    end
    love.graphics.draw(self.canvas, 0, 0)
  end,

  update = function (self)
    love.graphics.setCanvas(self.canvas)
    tiles_x = math.floor(self.display.width / self.tile_size.x)
    tiles_y = math.floor(self.display.height / self.tile_size.y)
    for x = 0, tiles_x-1 do
      for y = 0, tiles_y-1 do
        local color = nil
        c_x = x * self.tile_size.x
        c_y = y * self.tile_size.y
        local tile = self.map:getTile({x = self.top_left.x + x + 1, y = self.top_left.y + y + 1})
        if tile then
          if tile.exit then
            color = {200, 0, 0, 255}
          else
            love.graphics.setColor(unpack(tile.color))
          end
          if tile:actors() then
            self:drawTile({200,200,200,255}, c_x, c_y)
            tile:actors()[1].animation:draw(c_x, c_y)
          else
            self:drawTile(color, c_x, c_y)
          end
        end
      end
    end
    if self.top_left.x > 1 then self:drawArrow('up') end
    if self.top_left.y > 1 then self:drawArrow('left') end
    if (self.top_left.x + self.display.width)/self.tile_size.x < self.map.width then self:drawArrow('down') end
    if (self.top_left.y + self.display.width)/self.tile_size.y < self.map.height then self:drawArrow('right') end
    love.graphics.setCanvas()
    return self.canvas
  end,

  drawTile = function(self, color, x, y)
    if color then
      love.graphics.setColor(unpack(color))
    end
    love.graphics.rectangle('fill', c_x, c_y, self.tile_size.x, self.tile_size.y)
    love.graphics.setColor(255,255,255,255)
  end,

  drawArrow = function(self, direction)
    love.graphics.push()
    local arrow = self.arrows[direction]
    local x = self.display.width / 2 * arrow.t[1]
    local y = self.display.height / 2 * arrow.t[2]
    love.graphics.translate(x, y)
    love.graphics.polygon('fill', unpack(arrow.p(self)))
    love.graphics.pop()
  end,

  tiles_x = function(self)
    return math.floor(self.display.width / self.tile_size.x)
  end,

  tiles_y = function(self)
    return math.floor(self.display.height / self.tile_size.y)
  end,

  centerAt = function(self, position)
    x = position.x - math.floor(self:tiles_x() / 2)
    y = position.y - math.floor(self:tiles_y() / 2)
    if math.abs(self.top_left.x - x) >= 1 or math.abs(self.top_left.y - y) >= 1 then
      self.top_left = {x = x, y = y}
      self:fixTopLeft()
    end
    self:update()
  end,

  moveTopLeft = function(self, offset, dontMoveCursor)
    self.top_left.x = self.top_left.x + 3 * offset.x
    self.top_left.y = self.top_left.y + 3 * offset.y
    fixTopLeft()
    if not dontMoveCursor then
      self:moveCursor({x = offset.x * 3, y = offset.y * 3}, true)
    end
  end,

  fixTopLeft = function(self)
    max_x = math.floor(self.map.height - self:tiles_x())
    if self.top_left.x < 0 then
      self.top_left.x = 0
    elseif self.top_left.x > max_x then
      self.top_left.x = max_x + 1
    end
    max_y = math.floor(self.map.height - self:tiles_y())
    if self.top_left.y < 0 then
      self.top_left.y = 0
    elseif self.top_left.y > max_y then
      self.top_left.y = max_y + 1
    end
  end,

  moveCursor = function(self, offset, dontMoveTopLeft)
    self.cursor_position.x = self.cursor_position.x + offset.x
    self.cursor_position.y = self.cursor_position.y + offset.y
    if self.cursor_position.x < 1 then
      self.cursor_position.x = 1
    elseif self.cursor_position.x > self.map.width then
      self.cursor_position.x = self.map.width
    end
    if self.cursor_position.y < 1 then
      self.cursor_position.y = 1
    elseif self.cursor_position.y > self.map.height then
      self.cursor_position.y = self.map.height
    end
    if not dontMoveTopLeft then
      if self.cursor_position.x - 3 < self.top_left.x then
        self:moveTopLeft({x = - 1, y = 0}, true)
      elseif self.cursor_position.x + 3 > self.top_left.x + self:tiles_x() then
        self:moveTopLeft({x = 1, y = 0}, true)
      end
      if self.cursor_position.y - 3 < self.top_left.y then
        self:moveTopLeft({x = 0, y = - 1}, true)
      elseif self.cursor_position.y + 3 > self.top_left.y + self:tiles_y() then
        self:moveTopLeft({x = 0, y = 1}, true)
      end
    end
  end
})
