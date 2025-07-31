local Enemy = {}

function Enemy:new(x, y, assets)
    local obj = {
        x = x,
        y = y,
        width = 80,  -- Increased size
        height = 80, -- Increased size
        speed = 70,  -- Slightly increased speed
        image = assets.images.enemy,
        explosionImage = assets.images.enemyExplosion,
        isExploding = false,
        explosionTimer = 0,
        explosionDuration = 0.5
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Enemy:update(dt)
    if self.isExploding then
        self.explosionTimer = self.explosionTimer + dt
        if self.explosionTimer >= self.explosionDuration then
            return true  -- Signal to remove this enemy
        end
    else
        self.y = self.y + self.speed * dt
    end
    
    return false  -- Don't remove the enemy yet
end

function Enemy:draw()
    love.graphics.setColor(1, 1, 1)  -- Set color to white to avoid red tint
    if self.isExploding then
        love.graphics.draw(self.explosionImage, self.x, self.y, 0, self.width / self.explosionImage:getWidth(), self.height / self.explosionImage:getHeight())
    else
        love.graphics.draw(self.image, self.x, self.y, 0, self.width / self.image:getWidth(), self.height / self.image:getHeight())
    end
end

function Enemy:startExplosion()
    self.isExploding = true
    self.explosionTimer = 0
end

return Enemy

