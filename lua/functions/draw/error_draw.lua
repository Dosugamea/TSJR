function error_draw(reason)
	love.graphics.setScreen('top')
	love.graphics.setColor(255, 255, 255)
	love.graphics.print('Error appeared.', 5, 5)
	love.graphics.print('Error is watching you to be a member.', 5, 15)
	love.graphics.prints('Do you accept error?', 5, 25)
	love.graphics.prints('-> NO', 50, 35)
	love.graphics.setScreen('bottom')
	love.graphics.prints('Reason :', 5, 5)
	if reason == nil then
		love.graphics.prints('Unknown.', 5, 20)
	else
		love.graphics.prints(reason, 5, 20)
	end
end