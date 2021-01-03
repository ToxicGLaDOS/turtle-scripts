require "mockTurtle"
require "turtleState"

-- Check if inventory is full
--
---@return boolean
local function isInventoryFull()
    for i = 1, 16 , 1 do
        if turtle:getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

-- Deposits given inventory slots in a chest.
-- Will not drop items if no chest exists
--
---@param first number
---@param last number
---@return boolean
local function depositInventory(first, last)
    local success, chest = turtle:inspect()
    if chest == nil or (chest.name ~= "minecraft:chest" and chest.name ~= "ironchest:iron_chest") then
        print("chest not found to deposit inventory. Refusing to throw items on ground.")
        return false
    end

    for i = first, last, 1 do
        turtle:select(i)
        turtle:drop()
    end

    return true
end

local function refuel()
    turtle:moveTo(0, 0, 0, true)
    print(string.format("x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))
    turtle:face(1)
   for i = 1, 16, 1 do
        if turtle.getItemCount(i) == 0 then
            print("Found slot. Refueling")
            turtle:select(i)
            turtle:suck()
            turtle:refuel()
            turtle:suck()
            turtle:refuel()
            break
        end
    end
    local x = turtle.returnPoint.x
    local y = turtle.returnPoint.y
    local z = turtle.returnPoint.z
    turtle:moveTo(x, y, z, true)
    print(string.format("x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))
    turtle:face(turtle.previousFacing)
    turtle:changeOperation(turtle.previousOperation)
    -- This is for cleanness, but we shouldn't rely on these getting wiped out
    turtle.returnPoint = nil
    turtle.previousOperation = nil
    turtle.previousFacing = nil
end

local function checkFuel()
    if turtle:getFuelLevel() < 1000 then
        print("Refueling")
        turtle:changeOperation("Refueling")
        turtle.returnPoint = {x = turtle.pos.x,
                              y = turtle.pos.y,
                              z = turtle.pos.z}
        turtle.previousOperation = turtle.operation
        turtle.previousFacing = turtle.facing
        refuel()
    end
end

local function emptyInventory()
    turtle:moveTo(0, 0, 0, true)
    print(string.format("x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))
    turtle:face(2)
    depositInventory(2, 16)
    local x = turtle.returnPoint.x
    local y = turtle.returnPoint.y
    local z = turtle.returnPoint.z
    turtle:moveTo(x, y, z, true)
    print(string.format("x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))
    turtle:face(turtle.previousFacing)
    turtle:changeOperation(turtle.previousOperation)
    -- This is for cleanness, but we shouldn't rely on these getting wiped out
    turtle.returnPoint = nil
    turtle.previousOperation = nil
    turtle.previousFacing = nil
end

local function checkInventory()
    if isInventoryFull() then
        print("Inventory full")
        turtle:changeOperation("Emptying inventory")
        turtle.returnPoint = {x = turtle.pos.x,
                              y = turtle.pos.y,
                              z = turtle.pos.z}
        turtle.previousOperation = turtle.operation
        turtle.previousFacing = turtle.facing
        emptyInventory()
    end
end

local function digAndCheckInventory()
    turtle:dig()
    checkInventory()
end

local function digUpAndCheckInventory()
    turtle:digUp()
    checkInventory()
end

local function digDownAndCheckInventory()
    turtle:digDown()
    checkInventory()
end

local function forwardAndCheckFuel(force)
    turtle:forward(force)
    checkFuel()
end

local function upAndCheckFuel(force)
    turtle:up(force)
    checkFuel()
end

local function downAndCheckFuel(force)
    turtle:down(force)
    checkFuel()
end


local function begin()
    local chestSlotDetail = turtle:getItemDetail(1)
    if chestSlotDetail == nil or (chestSlotDetail.name ~= "minecraft:chest" and chestSlotDetail.name ~= "ironchest:iron_chest") then
        print("No chest in slot 1. Refusing to continue.")
        return false
    elseif chestSlotDetail.count < 2 then
        print("Less than 2 chests in slot 1. At least 2 are required")
        return false
    end
    turtle:face(0)
    turtle:select(1)
    -- Place fuel chest
    turtle:face(1)
    while not turtle:place() do
        turtle:dig()
    end

    -- Place items chest
    turtle:face(2)
    while not turtle:place() do
        turtle:dig()
    end
    turtle:face(0)
    return true
end

local function quarry()
    local width = turtle.width
    local length = turtle.length
    local depth = turtle.depth

    -- Realign to y if we broke down during a downward move
    for i = 1, turtle.pos.y % 3, 1 do
        turtle:digDownAndCheckInventory()
        turtle:down(true)
    end

    for y = turtle.pos.y, 1 - depth, -3 do

        local zDest = nil
        local zDir = nil

        if y % 2 == 0 then
            zDest = 1 - width
            zDir = -1
        else
            zDest = 0
            zDir = 1
        end

        for z = turtle.pos.z, zDest - zDir, zDir do
            digUpAndCheckInventory()
            digDownAndCheckInventory()

            local xDest = nil
            local xDir = nil
            -- If z % 2 == 1 then we're going forward
            if z % 2 == 0 then
                turtle:face(0)
                xDest = length - 1
                xDir = 1
            -- If z % 2 == 0 then we're going backward
            else
                turtle:face(2)
                xDest = 0
                xDir = -1
            end

            -- Dig forward to the desired length
            for x = turtle.pos.x, xDest - xDir, xDir do
                digAndCheckInventory()
                forwardAndCheckFuel(true)
                print(string.format("a x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))
                digUpAndCheckInventory()
                digDownAndCheckInventory()
            end

            -- Shift over one block and turn around
            turtle:face(3 + (2 * (y % 2)))
            digAndCheckInventory()
            forwardAndCheckFuel(true)
            print(string.format("b x: %i, y: %i, z: %i", turtle.pos.x, turtle.pos.y, turtle.pos.z))
            digUpAndCheckInventory()
            digDownAndCheckInventory()
            turtle:face(turtle.facing + 2)
        end
        -- Prevent us from doing this on the last iteration
        if y - 3 >= 1 - depth then
            for iter = 1, 3, 1 do
                digDownAndCheckInventory()
                downAndCheckFuel(true)
            end
        end
    end
    turtle:changeOperation("Done")
end

local function main()
    local turtle = TurtleState:new(turtle)
    local width = tonumber(arg[1])
    local length = tonumber(arg[2])
    local depth = tonumber(arg[3])

    turtle.width = width
    turtle.length = length
    turtle.depth = depth

    while turtle.operation ~= "Done" do
        if turtle.operation == "None" then
            print("Begin")
            if not begin() then
                error("Failed to start")
                return false
            end
            turtle:changeOperation("Quarrying")
        elseif turtle.operation == "Quarrying" then
            quarry()
        elseif turtle.operation == "Emptying inventory" then
            emptyInventory()
        elseif turtle.operation == "Refueling" then
            refuel()
        end
    end
end


main()