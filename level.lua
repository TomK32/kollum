
Level = class("Level")

function Level:initialize(level, seed)
  self.level = level
  self.seed = seed
  SimplexNoise.seedP(self.seed + self.level)
  self.map = Map(40, 23)
  self:placeExit({self.level + 1, self.level - 1}, self.seed)

  self:placeHero()
  self:placeVillain()
end

function Level:placeExit(exits, seed)
  if not exits[1] then return true end
  if exits[1] < 1 then return true end
  local pos = self:seedPosition(exits[1], exits[1]*2)
  local tile = self.map:getTile(pos)
  if not(tile) then
    return true
  end
  tile.exit = {level = exits[1]}
  self.map.makePath(tile)
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
    x = math.floor(((SimplexNoise.Noise2D(seed_x*0.1, seed_x*0.1)) * 120) % math.floor(scale_x * self.map.width-1) + offset_x),
    y = math.floor(((SimplexNoise.Noise2D(seed_y*0.1, seed_y*0.1)) * 120) % math.floor(scale_x * self.map.height-1) + offset_y)
  }
end

function Level:placeVillain()
  -- put villan in the bottom right
  local position = self:seedPosition(self.level, self.level + 1, 0.3, 0.3, self.map.width * 0.7, self.map.height * 0.7)
  local villain = Player(position, game.animations.villain, game, self)
  self.map:place(villain)
  table.insert(game.actors, villain)
end

function Level:placeHero()
  local position = self:seedPosition(self.level, self.level + 1, 0.3, 0.3)
  local hero = Hero(position, game.animations.hero, game, self)
  self.map:place(hero)
  table.insert(game.actors, hero)
end
