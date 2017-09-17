function pause_draw()
	--上画面表示
	love.graphics.setScreen('top')
	love.graphics.print("Paused", 175, 100)
	--下画面表示
	love.graphics.setScreen('bottom')
	love.graphics.print("Restart", 120, 50)
	love.graphics.print("Exit to menu", 120, 100)
	love.graphics.print("Exit to 3ds", 120, 150)
	
	if select == 1 then
	love.graphics.print(">", 90, 50)
	end
	if select == 2 then
	love.graphics.print(">", 90, 100)
	end
	if select == 3 then
	love.graphics.print(">", 90, 150)
	end
end