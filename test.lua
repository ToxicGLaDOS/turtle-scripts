-- shell.run("wget https://raw.githubusercontent.com/ToxicGLaDOS/json.lua/master/json.lua json.lua")
local json = require "json"
require "turtleState"
local mock = require "mockTurtle"

local turtle = TurtleState:new(turtle)



math.randomseed(os.time())
--math.randomseed(12.954)
for i = 1, 30, 1 do
    local rand = math.random(1, 6)
    if rand == 1 then
        turtle:forward()
    elseif rand == 2 then
        turtle:back()
    elseif rand == 3 then
        turtle:turnLeft()
    elseif rand == 4 then
        turtle:turnRight()
    elseif rand == 5 then
        turtle:up()
    elseif rand == 6 then
        turtle:down()
    end
end
print(string.format("x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))

turtle:moveTo(0, 0, 0, false)

print(string.format("x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))