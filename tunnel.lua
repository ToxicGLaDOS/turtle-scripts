print("begin tunnel.lua")

local function inList(check, list)
    for index, value in pairs(list) do
        if value == check then
            return true
        end
    end
    return false
end

local function dedupe(list)
    newList = {}
    for index, value in pairs(list) do
        if not inList(value, newList) then
            newList[#newList+1] = value
        end        
    end
    return newList
end


local function combine(l1, l2)
    newList = l1
    lenA = #newList

    for index, value in pairs(l2) do
        newList[lenA + 1 + index] = value
    end
    return newList
end

local function getNearbyBlocks()
    local blocks = {}
    local success, data = turtle.inspect()

    if not inList(data.name, blocks) then
        blocks[#blocks + 1] = data.name
    end

    turtle.turnLeft()

    local success, data = turtle.inspect()
    if not inList(data.name, blocks) then
        blocks[#blocks + 1] = data.name
    end

    turtle.turnRight()
    turtle.turnRight()

    local success, data = turtle.inspect()
    if not inList(data.name, blocks) then
        blocks[#blocks + 1] = data.name
    end

    turtle.turnLeft()

    local success, data = turtle.inspectUp()
    if not inList(data.name, blocks) then
        blocks[#blocks + 1] = data.name
    end

    local success, data = turtle.inspectDown()
    if not inList(data.name, blocks) then
        blocks[#blocks + 1] = data.name
    end
    return blocks
end

local function digUntilEmpty()
    while turtle.detect() do
        turtle.dig()
    end
end



local function turtleTunnel(distance)
    local allBlocks = {}
    for i = 0, distance, 1 do
        digUntilEmpty()
        turtle.forward()
        local blocks = getNearbyBlocks()
        allBlocks = dedupe(combine(allBlocks, blocks))
    end
    return allBlocks
end

local function main()
    local dist = arg[1]

    local blocks = getNearbyBlocks()
    print("Ores found:")
    turtle.refuel()
    local blocks = turtleTunnel(dist)
    turtle.digUp()
    turtle.up()
    turtle.turnLeft()
    turtle.turnLeft()
    blocks = dedupe(combine(blocks, turtleTunnel(dist)))
    for index, value in pairs(blocks) do
        print("Found: %s", value)
    end
end

main()


