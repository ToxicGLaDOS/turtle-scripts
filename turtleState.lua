local json = require "json"
-- Facing represents the direction the turtle is currently facing
-- 0 - positive x
-- 1 - positive z
-- 2 - negative x
-- 3 - negative z
TurtleState = {pos = {x = 0, y = 0, z = 0}, facing = 0, operation = "None"}

-- Creates a new TurtleState object.
-- If a table is passed in then it turns that object into a TurtleState object by
-- adding the functions and members of a TurtleState object
--
---@param o table Object to append to
---@return table Newly created object
function TurtleState:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    local file = io.open("turtleState.json", "r")
    if file ~= nil then
        local text = file:read("a")
        local state = json.decode(text)
        file:close()
        -- Set the state in the new object
        for k, v in pairs(state) do o[k] = v end
    end
    o:overrideFunctions()
    return o
end

-- Overrides the base turtle functions with the TurtleState versions
-- This is done by renaming them to _<function_name> so they may still be used
-- if really needed, and by the turtle state versions
--
---@return nil
function TurtleState:overrideFunctions()
    -- Running this function twice would cause _forward and forward to be the same method which
    -- would mean we lost the reference to the original forward method and all sorts of other issues
    -- so we have a guard here to make sure we don't do that
    if self._forward == nil then
        -- Rename the function
        self._forward = self.forward
        -- Remove the old one so the one in the metatable (the TurtleState version) is used
        self.forward = nil

        self._back = self.back
        self.back = nil

        self._up = self.up
        self.up = nil

        self._down = self.down
        self.down = nil

        self._turnLeft = self.turnLeft
        self.turnLeft = nil

        self._turnRight = self.turnRight
        self.turnRight = nil

        self._dig = self.dig
        self.dig = nil

        self._digUp = self.digUp
        self.digUp = nil

        self._digDown = self.digDown
        self.digDown = nil

        self._refuel = self.refuel
        self.refuel = nil

        self._getFuelLevel = self.getFuelLevel
        self.getFuelLevel = nil

        self._getFuelLimit = self.getFuelLimit
        self.getFuelLimit = nil

        self._select = self.select
        self.select = nil

        self._drop = self.drop
        self.drop = nil

        self._dropUp = self.dropUp
        self.dropUp = nil

        self._dropDown = self.dropDown
        self.dropDown = nil

        self._suck = self.suck
        self.suck = nil

        self._suckUp = self.suckUp
        self.suckUp = nil

        self._suckDown = self.suckDown
        self.suckDown = nil

        self._place = self.place
        self.place = nil

        self._placeUp = self.placeUp
        self.placeUp = nil

        self._placeDown = self.placeDown
        self.placeDown = nil

        self._getItemDetail = self.getItemDetail
        self.getItemDetail = nil

        self._getItemCount = self.getItemCount
        self.getItemCount = nil

        self._inspect = self.inspect
        self.inspect = nil

        self._inspectUp = self.inspectUp
        self.inspectUp = nil

        self._inspectDown = self.inspectDown
        self.inspectDown = nil
    end
end

-- Changes the current operation of the turtle
-- Errors if operation is nil
--
---@param operation string The new operation of the turtle
---@return nil
function TurtleState:changeOperation (operation)
    if operation == nil then
        error("Cannot change operation to nil")
    end
    self.operation = operation
end

-- Saves the turtles state to disk at turtleState.json
--
---@return nil
function TurtleState:saveState ()
    local file = io.open("turtleState.json", "w")
    local o = {}
    -- Make sure to copy over default values from the metatable and
    -- Get rid of all the stuff we don't want in the state that
    -- can't be represented in json
    for k, v in pairs(getmetatable(self)) do
        if type(v) ~= "function"
            and type(v) ~= "userdata"
            and type(v) ~= "thread"
            and k ~= "__index" then
            o[k] = v
        end
    end
    for k, v in pairs(self) do 
        if type(v) ~= "function"
            and type(v) ~= "userdata"
            and type(v) ~= "thread"
            and k ~= "native"
            and k ~= "__index" then
            o[k] = v
        end
    end

    local stringState = json.encode(o)
    file:write(stringState)
    file:close()
end


-- ################################# OVERRIDE FUNCTIONS #################################

-- Refuel the turtle
--
---@param amount number
---@return boolean
function TurtleState:refuel (amount)
    return self._refuel(amount)
end

-- Get fuel level of turtle
--
---@return number
function TurtleState:getFuelLevel ()
    return self._getFuelLevel()
end

-- Drop item in front of turtle
--
---@param amount number
---@return boolean, string?
function TurtleState:drop (amount)
    return self._drop(amount)
end

-- Drop item above turtle
--
---@param amount number
---@return boolean, string?
function TurtleState:dropUp (amount)
    return self._dropUp(amount)
end

-- Drop item below turtle
--
---@param amount number
---@return boolean, string?
function TurtleState:dropDown (amount)
    return self._dropDown(amount)
end

-- Suck an item off the ground or from a chest in front of the turtle
--
---@param amount number
---@return boolean, string?
function TurtleState:suck (amount)
    return self._suck(amount)
end

-- Suck an item off the ground or from a chest in above of the turtle
--
---@param amount number
---@return boolean, string?
function TurtleState:suckUp(amount)
    return self._suckUp(amount)
end

-- Suck an item off the ground or from a chest in below of the turtle
--
---@param amount number
---@return boolean, string?
function TurtleState:suckDown(amount)
    return self._suckDown(amount)
end

-- Place a block in front of the turtle
--
---@param signText? string
---@return boolean
function TurtleState:place(signText)
    return self._place(signText)
end

-- Place a block above the turtle
--
---@param signText? string
---@return boolean
function TurtleState:placeUp(signText)
    return self._placeUp(signText)
end

-- Place a block below the turtle
--
---@param signText? string
---@return boolean
function TurtleState:placeDown(signText)
    return self._placeDown(signText)
end

-- Inspect block in front of the turtle
--
---@return boolean, table/sting
function TurtleState:inspect()
    return self._inspect()
end

-- Inspect block in front of the turtle
--
---@return boolean, table/sting
function TurtleState:inspectUp()
    return self._inspectUp()
end

-- Inspect block in front of the turtle
--
---@return boolean, table/sting
function TurtleState:inspectDown()
    return self._inspectDown()
end


-- Select an inventory slot
--
---@param slot number
---@return boolean
function TurtleState:select(slot)
    return self._select(slot)
end

-- Get details for the item in the given slot
--
---@param slot number
---@return table
function TurtleState:getItemDetail(slot)
    return self._getItemDetail(slot)
end

-- Get number of items in a given slot
--
---@param slot number
---@return number
function TurtleState:getItemCount(slot)
    return self._getItemCount(slot)
end

-- Move the turtle's position forward one value.
-- The value that is changed (x, z) depends on the way the turtle is facing
--
---@param force boolean
---@return boolean
function TurtleState:forward (force)
    local success = nil
    if force then
        while not self._forward() do
            self:dig()
        end
        success = true
    else
        success = self._forward()
    end

    if success then
        if self.facing == 0 then
            self.pos.x = self.pos.x + 1
        elseif self.facing == 1 then
            self.pos.z = self.pos.z + 1
        elseif self.facing == 2 then
            self.pos.x = self.pos.x - 1
        elseif self.facing == 3 then
            self.pos.z = self.pos.z - 1
        else
            error("Turle has bad value for facing: ", self.facing)
        end
        self:saveState()
    end
    return success
end

-- Move the turtle's position back one value.
-- The value that is changed (x, z) depends on the way the turtle is facing
--
---@return boolean
function TurtleState:back ()
    local success = self._back()
    if success then
        if self.facing == 0 then
            self.pos.x = self.pos.x - 1
        elseif self.facing == 1 then
            self.pos.z = self.pos.z - 1
        elseif self.facing == 2 then
            self.pos.x = self.pos.x + 1
        elseif self.facing == 3 then
            self.pos.z = self.pos.z + 1
        else
            error("Turle has bad value for facing: ", self.facing)
        end
        self:saveState()
    end
    return success
end

-- Move the turtle up one value
--
---@param force boolean
---@return boolean
function TurtleState:up (force)
    local success = nil
    if force then
        while not self._up() do
            self:digUp()
        end
        success = true
    else
        success = self._up()
    end
    if success then
        self.pos.y = self.pos.y + 1
        self:saveState()
    end
    return success
end

-- Move the turtle down one value
--
---@param force boolean
---@return boolean
function TurtleState:down (force)
    local success = nil
    if force then
        while not self._down() do
            self:digDown()
        end
        success = true
    else
        success = self._down()
    end
    if success then
        self.pos.y = self.pos.y - 1
        self:saveState()
    end
    return success
end

-- Dig in front of the turtle
--
---@return boolean
function TurtleState:dig ()
    return self._dig()
end

-- Dig above of the turtle
--
---@return boolean
function TurtleState:digUp ()
    return self._digUp()
end

-- Dig below of the turtle
--
---@return boolean
function TurtleState:digDown ()
    return self._digDown()
end

-- Turns the turtle to the left
--
---@return boolean
function TurtleState:turnLeft ()
    local success = self._turnLeft()
    if success then
        self.facing = self.facing + 1
        self.facing = self.facing % 4
        self:saveState()
    end
    return success
end

-- Turns the turtle to the left
--
---@return boolean
function TurtleState:turnRight ()
    local success = self._turnRight()
    if success then
        self.facing = self.facing - 1
        self.facing = self.facing % 4
        self:saveState()
    end
    return success
end

-- ################################# HELPER FUNCTIONS #################################

-- Turns to face a specific direction
--
---@param direction number
---@return boolean
function TurtleState:face(direction)
    direction = direction % 4
    while self.facing ~= direction do
        self:turnLeft()
    end
    return true
end

-- Move to a specific coordinate in the turtles coordinate space
--
---@param x number
---@param y number
---@param z number
---@param force? boolean
---@return boolean
function TurtleState:moveTo(x, y, z, force)
    -- Align x
    if self.pos.x > x then
        self:face(2)
    elseif self.pos.x < x then
        self:face(0)
    end
    for i = 1, math.abs(self.pos.x - x), 1 do
        self:forward(force)
    end

    -- Align y
    if self.pos.y > y then
        for i = 1, self.pos.y - y, 1 do
            self:down(force)
        end
    elseif self.pos.y < y then
        for i = 1, y - self.pos.y, 1 do
            self:up(force)
        end
    end

    -- Align z
    if self.pos.z > z then
        self:face(3)
    elseif self.pos.z < z then
        self:face(1)
    end
    for i = 1, math.abs(self.pos.z - z), 1 do
        self:forward(force)
    end
end
