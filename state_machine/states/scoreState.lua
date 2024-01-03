--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

scoreState = Class{__includes = BaseState}

function scoreState:enter(params)
    self.medal = false
    self.score = params.score
    if self.score > gGold then
        self.medal = "golden";
        gGold = self.score
    elseif self.score > gSilver then
        self.medal = "silver";
        gSilver = self.score
    elseif self.score > gBronze then
        self.medal = "bronze";
        gBronze = self.score
    end
end

function scoreState:update(dt)
    -- go back to play if enter is pressed
    if wasPressed('enter') or wasPressed('return') then
        gStateMachine:change('countdownState')
    end
end

function scoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(flappyFont)
    if self.medal ~= false then
        love.graphics.printf('But you won ' .. self.medal .. ' medal', 0, 130, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end