SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")
Tile = class("Tile")
Tile:include({
  entities = {},
  color = nil,
  seedVal = 0,
  passable = true
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
    self.passable = false
  elseif s >= 80 and s < 120 then
    self.color = {s, s-20, math.floor(s / 2)}
  elseif s >= 120 and s < 200 then
    self.color = {s, s, s}
  else
    self.color = {s-40, s, s-40}
  end
end

function Tile:addEntity(entity)
  local class_name = entity.entity_type or entity.class.name
  if not self.entities[class_name] then
    self.entities[class_name] = {}
  end
  table.insert(self.entities[class_name], entity)
end

function Tile:removeEntity(entity)
  local class_name = entity.entity_type or entity.class.name
  for i, e in pairs(self.entities[class_name]) do
    if e == entity then
      table.remove(self.entities[class_name], i)
      return true
    end
  end
  return false
end

function Tile:actors()
  return self.entities['Actor']
end
