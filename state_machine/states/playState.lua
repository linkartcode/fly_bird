--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

playState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function playState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    self.paused = false
end

function playState:update(dt)
    if self.paused then
        if wasPressed('p') or mouseWasPressed(1) then
            sounds['pause']:play()
            sounds['music']:play()
            scrolling = true
            self.paused = false;
        else
            return
        end
    else
        if wasPressed('p') or mouseWasPressed(2) then
            sounds['music']:pause()
            sounds['pause']:play()
            scrolling = false;
            self.paused = true;
            return
        end
    end
    -- update timer for pipe spawning
    self.timer = self.timer + dt
    -- spawn a new pipe pair 
    if self.timer > (2 + (math.random(-2, 30) * 0.25)) then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('scoreState', {
                    score = self.score
                })
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('scoreState', {
            score = self.score
        })
    end
end

function playState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    if self.paused then
        love.graphics.setFont(flappyFont);
	    love.graphics.print("Pause", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 30);
	    love.graphics.setFont(mediumFont);
	    love.graphics.print("press 'p' to resume game", VIRTUAL_WIDTH / 2 - 100, VIRTUAL_HEIGHT / 2 + 10);
    end
end

--[[
    Called when this state is transitioned to from another state.
]]
function playState:enter(params)
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function playState:exit()
    scrolling = false
end