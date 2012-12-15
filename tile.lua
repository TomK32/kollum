SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")
Tile = class("Tile")
Tile:include({
  entities = {},
  color = nil,
  seedVal = 0
})

function Tile:initialize(x, y)
  self.entities = {}
  self:seed(x,y)
end

function Tile:seed(x, y)
  self.seedVal = math.floor((SimplexNoise.Noise2D(x*0.1, y*0.1) + 1) * 120) % 255
  local s = self.seedVal
  if s < 80 then
    self.color = {0,0,0}
  elseif s >= 80 and s < 120 then
    self.color = {s, s-20, math.floor(s / 2)}
  elseif s >= 120 and s < 200 then
    self.color = {s, s, s}
  else
    self.color = {s-40, s, s-40}
  end
end

function Tile:addEntity(self, entity)
  if not self.entities[entity.class.name] then
    self.entities[entity.class.name] = {}
  end
  table.insert(self.entities[entity.class.name], entity)
end

function removeEntity(self, entity)
  for i, e in pairs(self.entities[entity.class.name]) do
    if e == entity then
      table.remove(self.entities[entity.class.name], i)
      return true
    end
  end
  return false
end

