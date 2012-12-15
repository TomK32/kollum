-- Create animation.
local animations = {}
animations.valve = newAnimation(love.graphics.newImage("images/valve.png"), 32, 32, 0.3, 0)
animations.valve:setMode("loop")

animations.villain = {}
animations.villain.standing = newAnimation(love.graphics.newImage("images/kollum_standing.png"), 32, 32, 0.3, 0)

animations.hero = {}
animations.hero.standing = newAnimation(love.graphics.newImage("images/tombo_standing.png"), 32, 32, 0.3, 0)
return animations

