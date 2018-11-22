-- Load some default values for our rectangle.
local text
local direction
local level
local snake
local width;
local height;

function getPart(a,b)
    return {x=a, y=b}
end

function getFood() 
   return {
       x=math.random(20, 280), 
       y=math.random(20, 280), 
       power=math.random(1, 10)
    }
end

function isCollision(p1, p2, threshold)
    -- only check x to detect
    return math.sqrt(math.pow(p1.x - p2.x, 2) + math.pow(p1.y - p2.y, 2)) < threshold
end


function resetGame() 
    x, y = 20, 20
    speed = 1
    snake = {getPart(x, y)}
    snakeGrowth = 0
    food = getFood();
    hasLost = false
    direction = "down"
    score = 0
    taken = 0
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setNewFont(12)
    x, y = 20, 20, 10, 10
    snake_width, snake_height = 5, 5
    width, height = love.window.getMode()
    text = "Ormen"
    highScore = 0
    resetGame()
end

function love.update(dt)
    local deltaX = 0;
    local deltaY = 0;
    if hasLost then return end
    if direction == "left" then
        deltaX = -speed
    end
    if direction == "right" then
        deltaX = speed
    end
    if direction == "up" then
        deltaY = -speed
    end
    if direction == "down" then
        deltaY = speed
    end
    x = x + deltaX;
    y = y + deltaY;
    head = getPart(x, y);
    for k, v in pairs(snake) do
        if k > 10 and isCollision(head, v, 1) then
            hasLost = true
        end
    end
    if head.x >= width or head.x <= 0 or  head.y >= height or head.y <= 0 then
        hasLost = true
    end

    table.insert(snake, head)

    if (isCollision(head, food, 5)) then
        snakeGrowth = snakeGrowth + food.power
        food = getFood();
        score = score + food.power
        if (score > highScore) then
            highScore = score
        end
        speed = math.floor(taken / 10) + 1
        taken = taken + 1
    end

    if snakeGrowth > 0 then
        snakeGrowth = snakeGrowth - 1
    else
        table.remove(snake, 1)
    end

    --speed = speed + 0.01
end
 
function love.keypressed( key, isrepeat )
    if key == "up" or key == "down" or key == "left" or key == "right" then
        direction = key
        text = direction .. " " .. snakeGrowth
    end
    if hasLost and key == 'space' then
        resetGame()
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.setColor(0, 0.4, 0.4)
    for k, v in pairs(snake) do
        love.graphics.rectangle("fill", v.x, v.y, snake_width, snake_height)
    end
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", food.x, food.y, snake_height, snake_height)
    love.graphics.print(food.power, food.x + 10, food.y - 10)
    love.graphics.setColor(0, 1, 0)
    love.graphics.print( "SCORE " .. score , 5, 5)
    love.graphics.print( "LEVEL " .. speed , width - 100, 5)
    love.graphics.print( "HIGH SCORE " .. highScore , 5, height - 12)

    if hasLost then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print( "GAME OVER" ,  50, 100)
        love.graphics.print( "PRESS SPACE TO TRY AGAIN " ,  50, 120)
    end
end