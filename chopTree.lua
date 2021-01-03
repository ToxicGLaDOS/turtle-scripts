-- Chops a tree in front of the bot

-- Check if tree is in front of us

local _, data = turtle.inspect()

if data.name == "minecraft:log" then
    turtle.dig()
    turtle.forward()
    
    local treeHeight = 0
    local _, data = turtle.inspectUp()
    while data.name == "minecraft:log" do
        turtle.digUp()
        turtle.up()
        treeHeight = treeHeight + 1
        _, data = turtle.inspectUp()
    end
    for i = 1, treeHeight, 1 do
        turtle.down()
    end
end