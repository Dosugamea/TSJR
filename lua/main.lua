-- Aluosu for LövePotion

require("functions/var")
require("functions/beatmap/beatmap_jiro")
require("functions/beatmap/beatmap_osu")
require("functions/beatmap/beatmap_var")
require("functions/draw/game_draw")
require("functions/draw/ready_draw")
require("functions/draw/pause_draw")
require("functions/draw/debug_draw")
require("functions/update/game_update")
-- 起動時に読み込まれるfunction
function love.load()
	var()
	beatmap_var()
end

-- フレーム毎に実行される 画面書き換えのfunction
function love.draw()
	if status == "ready" then game_draw() ready_draw() end
	if status == "game" then game_draw() end	
	if status == "pause" then pause_draw() end
end

-- フレーム毎に実行される ゲームロジックのfunction
function love.update(dt)
	if status == "game" then game_update() 	timer = timer + dt end
end

-- ボタンが押されたときのfunction
function love.keypressed(key)
	-- debug
	pressed = key
	
	-- Aボタンが押されたら ドン を 代入する
	if key == 'a' then
		if status == 'game' then
			hit.don = 1
		end
		if status == 'pause' then
			if select == 1 then
				flag.sub_title = true
				status = "ready"
			end
			if select == 2 or select == 3 then
				love.event.quit()
			end
		end
	end
	-- Bボタンが押されたら カ を 代入する
	if key == 'b' then
		if status == 'game' then
			hit.ka = 1
		end
		if status == 'pause' then
			flag.sub_title = true
			status = "ready"
		end
	end

	-- 上ボタンが押されたら
	if key == 'dup' or key == 'cpadup' or key == 'cstickup' then
		if status == 'game' then
			hit.don = 1
		end
		if status == 'pause' then
			if select > 1 then
			select = select - 1
			else
				select = 3
			end
		end
	end
	-- 下ボタンが押されたら　
	if key == 'ddown' or key == 'cpaddown' or key == 'cstickdown' then
		if status == 'game' then
			hit.ka = 1
		end
		if status == 'pause' then
			if select < 3 then
			select = select + 1
			else
				select = 1
			end
		end
	end
	-- 左ボタンが押されたら
	if key == 'dleft' or key == 'cpadleft' or key == 'cstickleft' then
		if status == 'game' then
			hit.don = 1
		end
	end
	-- 右ボタンが押されたら　
	if key == 'dright' or key == 'cpadright' or key == 'cstickright' then
		if status == 'game' then
			hit.ka = 1
		end
	end
	-- Lボタンが押されたら
	if key == 'lbutton' then
		if status == 'game' then
			hit.don = 1
		end
	end
	-- Rボタンが押されたら
	if key == 'rbutton' then
		if status == 'game' then
			hit.ka = 1
		end
	end
	-- スタートボタンが押されたら pause を代入する
	if key == 'start' or key == 'select' then
		select = 1
		if status == 'game' or status == 'ready' then
			timer = 0
			donSound[0]:stop()
			kaSound[0]:stop()
			bgm:stop()
			status = "pause"
		else
			bgm:stop()
			flag.sub_title = true
			status = "ready"
			end
	end
end

-- 下画面が押されたときのfunction
function love.mousepressed()
	--debug
	touchX = love.mouse.getX( )
	touchY = love.mouse.getY( )
	local w
	local h
	local a
	if touchX < 160 then
		w = 160 - touchX
	else
		w = touchX - 160
	end	
	if touchY < 120 then
		h = 120 - touchY
	else
		h = touchY - 120
	end	
	w = w * w
	h = h * h
	a = w + h
	if a < r_a then
		hit.don = 1
	else
		hit.ka = 1
	end
	
	if status == "ready" then
		status = "game"
		if noBGM == false then
			bgm:play()
		end
	end
end

-- 下画面が離されたときのfunction
function love.mousereleased()
	-- 下画面が離されたら ドン に 0 を代入する
	hit.don = 0
	hit.ka = 0
end

-- ゲーム終了時のfunction
function love.quit()
	bgm:stop()
	donSound[0]:stop()
	kaSound[0]:stop()
	-- ビープ音を鳴らす
end