local Player = require("player")
local Enemy = require("enemy")
local Projectile = require("projectile")
local Assets = require("assets")

local player
local enemies = {}
local projectiles = {}
local score = 0
local maxHealth = 100
local health = maxHealth
local gameOver = false
local aimAngle = 0
local assets
local gameFont

function love.load()
    love.window.setMode(600, 1000, {resizable=false, vsync=true})  -- Larger portrait mode
    assets = Assets
    assets:load()
    player = Player:new(love.graphics.getWidth() / 2, love.graphics.getHeight() - 100)
    
    -- Load custom font
    gameFont = love.graphics.newFont("assets/font.ttf", 40)  -- Increased font size
    
    -- Start playing the background video
    if assets.backgroundVideo then
        assets.backgroundVideo:play()
    end
    
    for i = 1, 5 do
        table.insert(enemies, Enemy:new(love.math.random(50, love.graphics.getWidth() - 50), love.math.random(50, 300), assets))
    end
end

function love.update(dt)
    if gameOver then return end

    local mouseX, mouseY = love.mouse.getPosition()
    aimAngle = math.atan2(mouseY - player.y, mouseX - player.x)
    
    -- Check and restart video if necessary
    if assets.backgroundVideo and not assets.backgroundVideo:isPlaying() then
        assets.backgroundVideo:rewind()
        assets.backgroundVideo:play()
    end
    
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        local shouldRemove = enemy:update(dt)
        if shouldRemove then
            table.remove(enemies, i)
        elseif enemy.y > love.graphics.getHeight() then
            health = health - 10  -- Decrease health by 10 when an enemy reaches the bottom
            table.remove(enemies, i)
            if health <= 0 then
                health = 0
                gameOver = true
            end
        end
    end
    
    for i = #projectiles, 1, -1 do
        local projectile = projectiles[i]
        projectile:update(dt)
        
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if projectile:checkCollision(enemy) and not enemy.isExploding then
                enemy:startExplosion()
                table.remove(projectiles, i)
                score = score + 100
                break
            end
        end
        
        if projectile.y < 0 then
            table.remove(projectiles, i)
        end
    end
    
    if #enemies < 5 then
        table.insert(enemies, Enemy:new(love.math.random(50, love.graphics.getWidth() - 50), -50, assets))
    end
end

function love.draw()
    -- Draw background
    love.graphics.setColor(1, 1, 1, 1)
    if assets.backgroundVideo then
        love.graphics.draw(assets.backgroundVideo, 0, 0, 0, love.graphics.getWidth() / assets.backgroundVideo:getWidth(), love.graphics.getHeight() / assets.backgroundVideo:getHeight())
    else
        love.graphics.draw(assets.backgroundImage, 0, 0, 0, love.graphics.getWidth() / assets.backgroundImage:getWidth(), love.graphics.getHeight() / assets.backgroundImage:getHeight())
    end
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(assets.background, 0, 0, 0, love.graphics.getWidth() / assets.background:getWidth(), love.graphics.getHeight() / assets.background:getHeight())
    
    -- Draw game elements
    player:draw(aimAngle)
    
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
    
    for _, projectile in ipairs(projectiles) do
        projectile:draw()
    end
    
    -- Calculate the end point for the aim line (100 pixels away from the player)
    local aimLength = 100
    local aimEndX = player.x + aimLength * math.cos(aimAngle)
    local aimEndY = player.y + aimLength * math.sin(aimAngle)
    
    -- Draw aim line (red, thick line from player to the calculated point)
    love.graphics.setColor(1, 0, 0)  -- Red color
    love.graphics.setLineWidth(4)    -- Make the line thicker
    love.graphics.line(player.x, player.y, aimEndX, aimEndY)  -- Draw line to calculated endpoint
    
    -- Draw UI elements
    love.graphics.setFont(gameFont)
    
    -- Draw score
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Score: " .. score, 0, 45, love.graphics.getWidth(), "center")  -- Lowered by 25 pixels
    
    -- Define health bar dimensions
    local barWidth = 200
    local barHeight = 20
    local x = love.graphics.getWidth() / 2 - 10  -- Center horizontally
    local y = 120  -- Place health bar slightly lower than the text
    
    -- Calculate the filled width based on health
    local fillWidth = (health / maxHealth) * barWidth
    
    -- Draw "Health: " text before the health bar
    love.graphics.setColor(1, 1, 1)  -- White color for text
    love.graphics.print("Health: ", x - 90, y - 30)  -- Position text above the bar
    
    -- Draw background of health bar
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", x -80 , y + 30, barWidth, barHeight)
    
    -- Draw filled part of health bar
    love.graphics.setColor(0, 1, 0)  -- Green color
    love.graphics.rectangle("fill", x -80 , y + 30, fillWidth, barHeight)
    
    -- Draw outline of health bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x -80 , y + 30, barWidth, barHeight)
    
    -- Display Game Over message if gameOver is true
    if gameOver then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Game Over!\nFinal Score: " .. score, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
    if key == 'space' and not gameOver then
        table.insert(projectiles, Projectile:new(player.x, player.y, aimAngle, assets))
    end
end

function love.quit()
    if assets.backgroundVideo then
        assets.backgroundVideo:release()
    end
end

