--[[
    titleState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The titleState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

titleState = Class{__includes = BaseState}

function titleState:update(dt)
    -- transition to countdown when enter/return are pressed
    if wasPressed('enter') or wasPressed('return') then
        gStateMachine:change('countdownState')
    end
end

function titleState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end