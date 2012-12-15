require('tile')

Map = class("Map")
Map:include({

  initialize = function(self, width, height)
    self.width = width
    self.height = height
    self.map = {}
    self:randomize()
  end,

  randomize = function(self)
    for x = 1, self.width do
      table.insert(self.map, {})
      for y = 1, self.height do
        -- if you have very large maps you might want to move this to getTile
        self.map[x][y] = Tile(x, y)
      end
    end
  end,

  place = function(self, entity)
    tile = self:getTile(entity.position)
    if tile then
      tile:addEntity(entity)
    else
      print("Entity out of bound " .. entity.position.x .. ":" .. entity.position.y)
    end
  end,

  moveEntity = function(self, entity, old_position, new_position)
    local tile = self:getTile(old_position)
    if tile then
      if tile:removeEntity(entity) then
        self:place(entity)
      end
    end
  end,

  getTile = function(self, position)
    if self.map[position.x] then
      if self.map[position.x][position.y] then
        return self.map[position.x][position.y]
      else
        return nil
      end
    end
    return false
  end,

  fitIntoMap = function(self, position)
    if position.x < 0 then
      position.x = 0
    elseif position.x > self.width then
      position.x = self.width
    end
    if position.y < 0 then
      position.y = 0
    elseif position.y > self.height then
      position.y = self.height
    end
  end
})
