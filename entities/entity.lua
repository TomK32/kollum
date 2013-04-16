
Entity = class("Entity")
Entity.map = nil
Entity._type = nil

function Entity:initialize(options)
  for k, v in pairs(options) do
    self[k] = v
  end
  if self._type == nil then
    self._type = self.class.name
  end

  if not self.position then
    self.position = {x = 1, y = 1, z = 1}
  end
  if not self.position.width then
    self.position.width = 1
  end
  if not self.position.height then
    self.position.height = 1
  end
end

function Entity:draw()
end

function Entity:update(dt)
end

function Entity:includesPoint(point)
  if self.position.x < point.x and self.position.y < point.y then
    if self.position.x + self.position.width > point.x and
       self.position.y + self.position.height > point.y then
      return true
    end
  end
  return false
end
