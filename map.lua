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

-- clear unpassable fields from pos to the next passable field
function Map:makePath(tile, position, dir)
  directions = {{1,0}, {0,1}, {-1, 0}, {0, -1}}
  for i = 1, #directions do
    if last_dir then
      local dir = last_dir
      last_dir = nil
    else
      dir = directions[math.floor(math.random() * #directions)+1]
    end
    local new_pos = {x = position.x - dir[1], y = position.y - dir[2]}
    local other_tile = self:getTile(new_pos)
    if other_tile then
      if other_tile.passable then
        tile.color = {120,120,120, 255}
        tile.passable = true
        return true
      elseif self:makePath(other_tile, new_pos) then
        tile.color = {120,120,120, 255}
        tile.passable = true
        return true
      end
    end
  end
  for i, x in next, {-1, 0, 1} do
    for i, y in next, {-1, 0, 1} do
      local other_tile = self:getTile({x = position.x - x, y = position.y - y})
      if other_tile then
        if other_tile.passable then
          tile.passable = true
          return true
        end
      end
    end
  end
end
