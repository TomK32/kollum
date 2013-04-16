require 'treasure'
Level = class("Level")

function Level:initialize(level, seed)
  self.level = level
  self.seed = seed
  self.exits = {}
  self.treasures = {}
  self.players = {}
  self.dt = 0

  self.seed = self.seed + self.level
  local tries = 0
  repeat
    tries = tries + 1
    self.seed = self.seed + tries
    SimplexNoise.seedP(self.seed)
    self.map = Map(
      math.floor(love.graphics.getWidth() / MapView.tile_size.x)-1,
      math.floor(love.graphics.getHeight() / MapView.tile_size.y)-1)

    self.astar = AStar(self.map)

    self:placeExit({self.level + 1}, self.seed)
    self:placePlayer(game.animations.players[1])
    self:placePlayer(game.animations.players[1])

    self:placeTreasure()
  until self:goodMap() or tries > 10
  print(tries .. " tries for a good map")
end

function Level:update(dt)
  self.dt = self.dt + dt
end

function Level:placeExit(exits, seed)
  if not exits[1] then return true end
  if exits[1] < 1 then return true end
  local pos = self:seedPosition(exits[1], exits[1]*2, 0.5, 0.5, self.map.width / 4, self.map.height / 4)
  local tile = self.map:getTile(pos)
  if not(tile) then
    return true
  end
  tile.exit = {level = exits[1]}
  self.map:makePath(tile, pos)
  table.insert(self.exits, {position = pos, level = exits[1]})
  table.remove(exits, 1)
  self:placeExit(exits, seed + 2)
end

-- int, int, 0..1, 0..1, int, int
function Level:seedPosition(seed_x,seed_y, scale_x, scale_y, offset_x, offset_y)
  scale_x = scale_x or 1
  scale_y = scale_y or 1
  offset_x = offset_x or 0
  offset_y = offset_y or 0
  return {
    x = math.floor(((SimplexNoise.Noise2D(seed_x*0.1, seed_x*0.1)) * 120) % math.floor(scale_x * self.map.width-1) + offset_x) + 1,
    y = math.floor(((SimplexNoise.Noise2D(seed_y*0.1, seed_y*0.1)) * 120) % math.floor(scale_x * self.map.height-1) + offset_y) + 1
  }
end

function Level:placePlayer(animations)
  local position = self:seedPosition(self.level, self.level + 1, 0.3, 0.3)
  player = Player(position, animations, self)
  self.map:place(player)
  self.map:makePath(self.map:getTile(position), position)
  table.insert(self.players, player)
end

function Level:placeTreasure()
  local treasureSeed = self.level + 10
  for i = 1, math.min(math.floor(self.level / 5) + 1, 4) do
    local position = self:seedPosition(treasureSeed , treasureSeed, 0.3, 0.3, self.map.width * 0.4, self.map.height * 0.4)
    treasureSeed = treasureSeed + i
    local treasure = Treasure(position, game.animations.treasure, self)
    table.insert(self.treasures, treasure)
    self.map:place(treasure)
    self.map:makePath(self.map:getTile(position), position)
  end
end

function Level:goodMap()
  for i, player in ipairs(self.players) do
    if player.position and not self.astar:findPath(player.position, self.exits[1].position) then
      return false
    end
  end
  return true
end
