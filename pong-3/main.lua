--[[
	
	pong-3
    "The Paddle Update"
	
    -- Main Program --
    
	Author:  Fábio Moreira
	This game construction is from Harvard CS50 Intro to Game Dev, by Colton Ogden.

	Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
	the ball past your opponent's edge. First to 10 points wins.
	
	This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]

-- push is a library that allows us to draw our game at virtual
-- resolution, instead of however large our window is; used to 
-- provide a more retro aesthetic

-- https://github.com/Ulydev/push
push = require 'push'


-- constant variables that defines the window screen size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- constant variables that defines the retro aspect size
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at witch we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]

function love.load()
    --use the nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
    -- and graphics; try removing this function to see the diference!
    love.graphics.setDefaultFilter('nearest', 'nearest')    
    
    -- more "retro-looking" font object we can use for any text
    -- store the font type into the variable "smallfont" to be used later
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- larger font for drawing the score on the screen
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set LOVE2D's active font to the smallFont object(variable)
    love.graphics.setFont(smallFont)

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions; replaces our love.window.setMode call
    -- from the last example
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false;
        resizable = false;
        vsync = true
    })

    -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    player1Score = 0
    player2Score = 0

    -- paddle positions on the Y axis (they can only move up or down)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

--[[ 
    Runs every frame, with "dt" passed in, our delta in seconds
    since last frame, which LOVE2D supplies us.
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player1Y = player1Y + PADDLE_SPEED * dt
    end
    
    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then        
        -- add positive paddle speed to current Y scaled by deltaTime
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]

function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'escape' then
        --fucntion löve give us to terminate application
        love.event.quit()
    end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]

function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- clear the scrren with a specified color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40, 45, 52, 0.3)

    -- draw welcome text toward the top of the screen
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- draw score on to the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 8)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 8)

    -- draw the lines to be used as a paddles and ball in the game
    -- love.graphics.rectangle (mode, x, y, width, height)
    -- mode can be set to 'fill' or 'line'; other four params are
    -- position on the screen and size dimensions of object

    -- draw left side paddle
    love.graphics.rectangle ('fill', 5, player1Y, 5, 20)
    
    -- draw right side paddle
    love.graphics.rectangle ('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
    
    -- draw the ball
    love.graphics.rectangle ('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    
    --end rendering at virtual resolution
    push:apply('end')
end