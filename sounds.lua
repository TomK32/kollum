
local sounds = {}

sounds.startmenu = love.audio.newSource("sounds/tekno2.wav", "static")
sounds.startmenu:setLooping(true)

sounds.hit = love.audio.newSource("sounds/hit.wav", "static")
sounds.level = love.audio.newSource("sounds/level.wav", "static")
sounds.pickup_loose = love.audio.newSource("sounds/pickup_loose.wav", "static")
sounds.pickup_coin = love.audio.newSource("sounds/pickup_coin.wav", "static")


return sounds
