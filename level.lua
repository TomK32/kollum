
Level = class("Level")

function Level:initialize(level, seed)
  self.level = level
  self.seed = seed
  SimplexNoise.seedP(self.seed + self.level)
  self.map = Map(100, 100)

  self:placeHero()
  self:placeVillain()
end

function Level:placeVillain()

end

function Level:placeHero()

end
