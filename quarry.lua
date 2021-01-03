print("Begin quarry.lua")


local function depositInventory(first, last)
    local success, chest = turtle.inspect()
    if chest == nil or (chest.name ~= "minecraft:chest" and chest.name ~= "ironchest:iron_chest") then
        print("chest not found to deposit inventory. Refusing to throw items on ground.")
        return false
    end

    for i = first, last, 1 do
        turtle.select(i)
        turtle.drop()
    end

    return true
end

local function digUntilMoveForward()
    while not turtle.forward() do 
        turtle.dig()
    end
end

local function isInventoryFull()
    for i = 1, 16 , 1 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

local function returnToLayerHome(x, y, turns)
 -- Turns is either 2 or 0 now. 2 means we're facing the wrong way 0 means we're facing the same direction we started
    print("Returning to layer home")
    print("x %s, y %s, turns %s", tostring(x), tostring(y), tostring(turns))
    if turns == 2 then
        turtle.turnRight()
        for i = 1, x - 1, 1 do
            digUntilMoveForward()
        end
        turtle.turnLeft()
        for i = 1, y - 1, 1 do
            digUntilMoveForward()
        end
        turtle.turnRight()
        turtle.turnRight()
    else
        turtle.turnLeft()
        for i = 1, x - 1, 1 do
            digUntilMoveForward()
        end
        turtle.turnLeft()
        for i = 1, y - 1, 1 do
            digUntilMoveForward()
        end
        turtle.turnRight()
        turtle.turnRight()
    end

end

local function mineLayer(width, length)
    print("Beginning layer")
    local turns = 0
    local x = 1
    local y = 1
    for i = 1, width, 1 do
        for j = 1, length - 1, 1 do
            if isInventoryFull() then
                print("Inventory full")
                returnToLayerHome(x, y, turns)
                return 1
            end
            if turtle.getFuelLevel() < 1000 then
                print("Low fuel")
                returnToLayerHome(x, y, turns)
                return 2
            end

            -- This might seem redudant, but it's basically the simplest way to make sure
            -- we get all the corners
            turtle.digUp()
            turtle.digDown()
            digUntilMoveForward()
            turtle.digUp()
            turtle.digDown()

            if i % 2 == 1 then
                y = y + 1
            else
                y = y - 1
            end
        end

        if i < width then
            -- Turn and move forward one
            if i % 2 == 0 then
                turtle.turnLeft()
                turns = turns - 1
            else
                turtle.turnRight()
                turns = turns + 1
            end
            -- This might seem redudant, but it's basically the simplest way to make sure
            -- we get all the corners
            turtle.digDown()
            turtle.digUp()
            digUntilMoveForward()
            turtle.digDown()
            turtle.digUp()

            x = x + 1
            
            if i % 2 == 0 then
                turtle.turnLeft()
                turns = turns - 1
            else
                turtle.turnRight()
                turns = turns + 1
            end
        end
    end
    returnToLayerHome(x, y, turns)
    return 0
end

local function main()


    local chestSlot = turtle.getItemDetail(1)
    if chestSlot == nil or (chestSlot.name ~= "minecraft:chest" and chestSlot.name ~= "ironchest:iron_chest") then
        print("No chest in slot 1. Refusing to continue.")
        return
    elseif chestSlot.count < 2 then
        print("Less than 2 chests in slot 1. At least 2 are required")
        return
    end
    -- Place fuel chest
    turtle.turnLeft()
    while not turtle.place() do
        turtle.dig()
    end
    
    -- Place items chest
    turtle.turnLeft()
    turtle.select(1)
    while not turtle.place() do
        turtle.dig()
    end
    turtle.turnLeft()
    turtle.turnLeft()


    local width = tonumber(arg[1])
    local length = tonumber(arg[2])
    local depth = tonumber(arg[3])

    for i = 1, depth, 1 do
        if i % 3 == 1 then
            local returnCode = mineLayer(length, width)
            while returnCode ~= 0 do
                for j = 1, i - 1, 1 do
                    turtle.up()
                end
                if returnCode == 1 then
                    turtle.turnLeft()
                    turtle.turnLeft()

                    if not depositInventory(2, 16) then
                        print("Panic: Deposit chest not found. Stopping quarry")
                        return
                    end
                    turtle.turnLeft()
                    turtle.turnLeft()
                elseif returnCode == 2 then
                    print("Low on fuel. Looking for available inventory slot")
                    for i = 1, 16, 1 do
                        if turtle.getItemCount(i) == 0 then
                            print("Found slot. Refueling")
                            turtle.select(i)
                            turtle.turnLeft()
                            turtle.suck()
                            turtle.refuel()
                            turtle.suck()
                            turtle.refuel()
                            turtle.turnRight()
                            break
                        end
                    end
                else
                    print("Unknown return code ", returnCode)
                    return
                end
                for j = 1, i - 1, 1 do
                    turtle.down()
                end
                returnCode = mineLayer(length, width)
            end
        end
        -- This if statement prevents the turtle from
        -- mining an extra block down at the end of the quarry
        if i < depth then
            turtle.digDown()
            turtle.down()
        end
    end
    for i = 1, depth, 1 do
        turtle.up()
    end

end

main()