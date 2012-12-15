-- Create animation.
local animations = {}
animations.valve = newAnimation(love.graphics.newImage("images/valve.png"), 32, 32, 0.3, 0)
animations.valve:setMode("loop")
return animations

