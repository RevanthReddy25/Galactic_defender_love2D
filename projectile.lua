local Projectile = {}

function Projectile:new(x, y, angle, assets)
    local obj = {
        x = x,
        y = y,
        radius = 15,  -- Increased size
        speed = 600,  -- Slightly increased speed
        angle = angle,
        image = assets.images.bullet
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Projectile:update(dt)
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
end

function Projectile:draw()
    love.graphics.setColor(1, 1, 1)  -- Set color to white
    love.graphics.draw(self.image, self.x - self.radius, self.y - self.radius, self.angle, self.radius * 2 / self.image:getWidth(), self.radius * 2 / self.image:getHeight())
end

function Projectile:checkCollision(enemy)
    local distance = math.sqrt((self.x - enemy.x - enemy.width/2)^2 + (self.y - enemy.y - enemy.height/2)^2)
    return distance < self.radius + enemy.width/2
end

return Projectile

