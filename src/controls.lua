-- contains all funtion to input from mouse and keyboard

function love.keypressed(key)
	-- add to our table of keys pressed this frame
	keysPressed[key] = true

	if key == 'escape' then
		 love.event.quit()
	end
end

function love.mousepressed(x, y, button)
	mousePressed[button] = true
end

function wasPressed(key)
	return keysPressed[key]
end

function mouseWasPressed(button)
	return mousePressed[button]
end
