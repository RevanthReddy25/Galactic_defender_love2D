local Assets = {}

function Assets:load()
    -- Load background video with error handling
    local success, video = pcall(love.graphics.newVideo, "assets/bg.ogv")
    if success then
        self.backgroundVideo = video
    else
        print("Failed to load background video. Using image background instead.")
        self.backgroundVideo = nil
    end

    -- Load fallback background image
    self.backgroundImage = love.graphics.newImage("assets/background.png")
 
    self.background = love.graphics.newImage("assets/spaceship.png")   
    -- Load game object images
    self.images = {
        enemy = love.graphics.newImage("assets/enemy.png"),
        enemyExplosion = love.graphics.newImage("assets/explosion.png"),
        bullet = love.graphics.newImage("assets/bullet.png")
    }
end

return Assets

