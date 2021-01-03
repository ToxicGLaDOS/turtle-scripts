local function digUntilMove(direction, amount)
    local moveFunction = nil
    local digFunction = nil
    if direction == "up" then 
        moveFunction = turtle.up
        digFunction = turtle.digUp
    elseif direction == "down" then
        moveFunction = turtle.down
        digFunction = turtle.digDown
    elseif direction == "forward" then
        moveFunction = turtle.forward
        digFunction = turtle.dig
    else
        print("Unknown direction ", direction)
    end



    if amount == nil then
        amount = 1
    end
    for i = 1, amount, 1 do
        while not moveFunction() do 
            digFunction()
        end
    end
end

local function depositinventory(first, last, filter)
    local success, chest = turtle.inspect()
    if chest == nil or chest.name ~= "minecraft:chest" then
        print("chest not found to deposit inventory. Refusing to throw items on ground.")
        return false
    end

    for i = first, last, 1 do
        turtle.select(i)
        local itemDetail = turtle.getItemDetail()

        if itemDetail ~= nil then
            if filter == nil or itemDetail.name == filter then
                turtle.drop()
            end
        end
    end

    return true
end

local function chopTree()
    local _, data = turtle.inspect()

    if data.name == "minecraft:log" then
        digUntilMove("forward")
        turtle.digDown()

        local treeHeight = 1
        local _, data = turtle.inspectUp()
        while data.name == "minecraft:log" do
            digUntilMove("up")
            treeHeight = treeHeight + 1
            _, data = turtle.inspectUp()
        end
        for i = 1, treeHeight - 1, 1 do
            digUntilMove("down")
        end
        turtle.select(1)
        turtle.placeDown()
        return true
    end
    return false
end

local function collectSaplings(length)
    print("Collecting saplings...")
    turtle.turnRight()
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()

    turtle.turnLeft()
    turtle.suck()
   
    for i = 1, length + 1, 1 do
       digUntilMove("forward")
       turtle.suck()
    end

    turtle.turnLeft()
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()

    turtle.turnLeft()
    turtle.suck()

    for i = 1, length + 2, 1 do
        digUntilMove("forward")
        turtle.suck()
    end

    turtle.turnLeft()
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()

    turtle.turnLeft()
    turtle.suck()

    for i = 1, length + 4, 1 do
        digUntilMove("forward")
        turtle.suck()
    end

    turtle.turnLeft()
    turtle.suck()

    digUntilMove("forward")
    turtle.suck()
    digUntilMove("forward")
    turtle.suck()
    digUntilMove("forward")
    turtle.suck()
    digUntilMove("forward")
    turtle.suck()

    turtle.turnLeft()
    turtle.suck()

    for i = 1, length + 3, 1 do
        digUntilMove("forward")
        turtle.suck()
    end

    turtle.turnLeft()
    turtle.suck()
    
    digUntilMove("forward")
    turtle.suck()
    digUntilMove("forward")
    turtle.suck()

    turtle.turnLeft()
    turtle.suck()
end


local function main()
    local farmLength = 10
    local loopCount = 0
    while true do
        digUntilMove("up")
        for i = 1, farmLength + 1, 1 do
            local success, data = turtle.inspect()
            if not success then
                turtle.forward()
            elseif data.name == "minecraft:leaves" then
                digUntilMove("forward")
            elseif data.name == "minecraft:log" then
                chopTree()
            else
                print("Panic: Unknown block in front stopping program.")
                return
            end
        end
        turtle.turnRight()
        turtle.turnRight()
        digUntilMove("down")
        collectSaplings(farmLength)
        loopCount = loopCount + 1
        if loopCount % 2 == 0 then
            turtle.turnRight()
            turtle.turnRight()
            digUntilMove("forward", 3)
            turtle.turnLeft()
            depositinventory(2, 16, "minecraft:sapling")
            turtle.turnRight()
            turtle.turnRight()
            depositinventory(2, 16, "minecraft:log")
            turtle.turnRight()

            local fuelLevel = turtle.getFuelLevel()
            -- 80 is the fuel from one charcoal
            if fuelLevel + 80 * 64 < turtle.getFuelLimit() then
                turtle.select(16)
                turtle.suckUp()
                turtle.refuel()
            end

            digUntilMove("forward", 3)
        end
        print("Sleeping for 4 minutes")
        os.sleep(240)
    end
end

main()