-- contains all paths to required files
require 'src/paths'
-- contains all global constants definitions
require 'src/constants'
-- contains all funtion to input from mouse and keyboard
require 'src/controls'

local background = love.graphics.newImage('graphics/background.png')
local ground = love.graphics.newImage('graphics/ground.png')

local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

function love.load()
   love.graphics.setDefaultFilter('nearest', 'nearest')
   math.randomseed(os.time())
   love.window.setTitle('Fifty Bird')
   -- initialize our nice-looking retro text fonts
   smallFont = love.graphics.newFont('fonts/font.ttf', 8)
   mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
   flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
   hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
   love.graphics.setFont(flappyFont)

   -- initialize our table of sounds
   sounds = {
      ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
      ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
      ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
      -- https://freesound.org/people/xsgianni/sounds/388079/
      ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static'),
      ['pause'] = love.audio.newSource('sounds/pause.wav', 'static')
   }
   -- kick off music
   sounds['music']:setLooping(true)
   sounds['music']:play()
   -- initialize our virtual resolution
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       vsync = true,
       fullscreen = false,
       resizable = true
   })
   -- initialize state machine with all state-returning functions
   gStateMachine = StateMachine {
      ['titleState'] = function() return titleState() end,
      ['countdownState'] = function() return countdownState() end,
      ['playState'] = function() return playState() end,
      ['scoreState'] = function() return scoreState() end
   }
   gStateMachine:change('titleState')

   -- initialize input tables
   keysPressed = {}
   mousePressed = {}

   scrolling = true

   gGold = 0;
   gSilver = 0;
   gBronze = 0;
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if scrolling then
        -- scroll our background and ground, looping back to 0 after a certain amount
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end
    gStateMachine:update(dt)

    keysPressed = {}
    mousePressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
