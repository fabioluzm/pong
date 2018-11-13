--[[
	
	pong-4
    "The Ball Update"
	
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
    
    -- "seed" the RNG  so that calls  to random are always random
    -- use current time, since that vary on start up every time
    math.randomseed(os.time())
    
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

    -- velocity and position variables for our ball when play starts
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    -- math.random returns a random value between the left and right number
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    -- game state variable used to transition between different parts of the game
    -- (used for beggining, menus, main game highscore list, etc)
    -- we will use this to determine behavior during render and update
    gameState = 'start'
end

--[[ 
    Runs every frame, with "dt" passed in, our delta in seconds
    since last frame, which LOVE2D supplies us.
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        -- now we clamp our position between the bounds of the screen
        -- math.max returns the greather of two values; 0 and player Y
        -- will ensure we don't go above it
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        -- math.min returns the less of two values; bottom of the edge minus
        -- and player Y will ensure we don't go below it
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end
    
    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then        
        -- add positive paddle speed to current Y scaled by deltaTime
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement os framerate-independent
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function löve give us to terminate application
        love.event.quit()
    -- if we press enter during the start of the game, we'll go into play mode
    -- during play mode, the ball will move in a random direction
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            -- start ball's position in the middle of the screen
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- give ball's x and y velocity a random starting value
            -- the and/or pattern here is Lua's way of accomplishing a ternary operation
            -- in other programming languages like C
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- clear the screen with a specified color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40, 45, 52, 0.3)

    -- draw different things based on the state of the game
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- draw left side paddle (using the players'Y variable)
    love.graphics.rectangle ('fill', 5, player1Y, 5, 20)
    
    -- draw right side paddle
    love.graphics.rectangle ('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
    
    -- draw the ball (center)
    love.graphics.rectangle ('fill', ballX, ballY, 4, 4)

    --end rendering at virtual resolution
    push:apply('end')
end