function game_update()
	-- [Update] 譜面の読み込み
	if mode == "jiro" then jiro_beatmap_update() end
	if mode == "osu" then end
	
	-- [Anim] Pippidonの切り替え
	if timer > old_timer_pippi + beat_time then
			if pippidon.anim < 1 then
				pippidon.anim = pippidon.anim + 1
			else
				pippidon.anim = 0
			end
	end
	
	-- [Sound] i番目の don/ka が再生されているかのフラグを作成
	for i in pairs(playing_don) do
		playing_don[i] = donSound:isPlaying( )
	end
	i = 0
	for i in pairs(playing_ka) do
		playing_ka[i] = kaSound:isPlaying( )
	end

	-- [Anim] サブタイトルの上下 このロジックの実行の度に座標変更
	if flag.sub_title == true then
		sub_title_cnt = sub_title_cnt +1
		if sub_title_cnt > 0 and sub_title_cnt < 5 then
		subnameY = subnameY - 3
		end
		if sub_title_cnt > 5 and sub_title_cnt < 13 then
		subnameY = subnameY + 2
		end
		if sub_title_cnt > 30 then
		subnameY = 400
		end
	end
	
	-- [Anim] 下画面太鼓の上下 このロジックの実行の度に座標変更
	if flag.taiko == true then
		taiko_updown_cnt = taiko_updown_cnt +1
		if taiko_updown_cnt > 0 and taiko_updown_cnt < 2 then
		bottom.taiko_Y = bottom.taiko_Y + 5
		end
		if taiko_updown_cnt > 2 and taiko_updown_cnt < 4 then
		bottom.taiko_Y = bottom.taiko_Y - 5
		end
		if taiko_updown_cnt == 5 then
		flag.taiko = false
		taiko_updown_cnt = 0
		end
	end
	
	-- [Anim] 1枚目のX座標が -400以下(画面左の奥)になったとき　0(画面右端)に戻す
	if background.sliderX < -400 then
		background.sliderX = 0
	else
		background.sliderX = background.sliderX - 3
	end
	
	-- [Anim] 2枚目のX座標が 0(画面の左端) 以下になったとき　400(画面右の奥)に戻す
	if background.slider2X < 0 then
		background.slider2X = 400
	else
		background.slider2X = background.slider2X - 3
	end
	
	-- [Anim] hitに何かしらの値が入ったら flag.taikoをtrueに
	if hit.don == 1 or hit.ka == 1 and flag.taiko == false then
			flag.taiko = true
	end
end