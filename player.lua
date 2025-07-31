local Player = {}

function Player:new(x, y)
    local obj = {
        x = x,
        y = y,
        width = 60,
        height = 60
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:draw(aimAngle)
    -- The player is now invisible
end

return Player

