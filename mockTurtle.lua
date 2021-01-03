turtle = {}

local function forward()
    --print("Move forward")
    return true
end

local function down()
    --print("Move down")
    return true
end

local function up()
    --print("Move up")
    return true
end

local function back()
    --print("Move back")
    return true
end

local function turnLeft()
    --print("Turn left")
    return true
end

local function turnRight()
    --print("Turn right")
    return true
end

local function dig()
    --print("Dig")
    return true
end

local function digUp()
    --print("Dig up")
    return true
end

local function digDown()
    --print("Dig down")
    return true
end

local function suck()
    --print("Suck")
    return true
end

local function suckUp()
    --print("Suck up")
    return true
end

local function suckDown()
    --print("Suck down")
    return true
end

local function drop()
    --print("Drop")
    return true
end

local function dropUp()
    --print("Drop up")
    return true
end

local function dropDown()
    --print("Drop down")
    return true
end

local function place()
    --print("Place")
    return true
end

local function placeUp()
    --print("Place up")
    return true
end

local function placeDown()
    --print("Place down")
    return true
end

local function getFuelLevel()
    --print("Getting fuel level")
    return math.random(950, 2000)
end

local function getFuelLimit()
    --print("Getting fuel limit")
    return 10000
end

local function refuel()
    return true
end

local function select(slot)
    --print("Selecting")
    return true
end

local function getItemDetail(slot)
    --print("Getting item details")
    return {name = "minecraft:chest", count = 2}
end

local function getItemCount(slot)
    return math.random(0,4)
    --return math.random(0,64)
end

local function inspect()
    return true, {name = "minecraft:chest"}
end

local function inspectUp()
    return true, {name = "minecraft:chest"}
end

local function inspectDown()
    return true, {name = "minecraft:chest"}
end

turtle.forward = forward
turtle.back = back
turtle.down = down
turtle.up = up
turtle.turnLeft = turnLeft
turtle.turnRight = turnRight
turtle.dig = dig
turtle.digUp = digUp
turtle.digDown = digDown
turtle.suck = suck
turtle.suckUp = suckUp
turtle.suckDown = suckDown
turtle.drop = drop
turtle.dropUp = dropUp
turtle.dropDown = dropDown
turtle.place = place
turtle.placeUp = placeUp
turtle.placeDown = placeDown
turtle.getFuelLevel = getFuelLevel
turtle.getFuelLimit = getFuelLimit
turtle.refuel = refuel
turtle.select = select
turtle.getItemDetail = getItemDetail
turtle.getItemCount = getItemCount
turtle.inspect = inspect
turtle.inspectUp = inspectUp
turtle.inspectDown = inspectDown