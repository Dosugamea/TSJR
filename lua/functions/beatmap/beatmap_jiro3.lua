function jiro_beatmap_var()
	--各フラグの宣言 兼 デバッグ用
	
	course_l = course_line[4] --　コース一覧から指定した番号の行番号を取得 今回は強制 Easy
	level_l = level_line[4] --レベル一覧から指定した番号 今回は強制3
	bm_line_n = start_line[4] + 1  -- スタート地点一覧からcourse_line に一番近い番号 今回は強制的にEasyの行から開始
	wait_notes = {} -- 各行の音符数を保存するテーブル
	notes = true -- この行は数字であるか、のフラグ
	notes_end = false
	
	level = string.sub(data_line[level_l], 7) -- レベルの数字切り出し
	course = string.sub(data_line[course_l], 8) -- コースの名称の切り出し	
	
	
	
	-- 音符数をテーブルに記録
	-- repeat
		-- 現在の行のデータを読み込む
		-- local cache = data_line[bm_line_n]
		-- とりあえず音符として数える(文字によって音符であるかないかを変える)
		-- notes = true
		-- データが一致すれば それは音符ではない。 行を変える
		-- if cache == "/" or length == 0 then wait_notes[cnt[6]] = nil end
		-- if cache == "," then wait_notes[cnt[6]] = "max" end
		-- if cache == "#GOGOSTART" then end
		-- if cache == "#GOGOEND" then end
		-- if cache == "#EN" or cache == "#END" then notes_end = true end
	
		-- if notes ~= true then end
		-- next_l()
	-- until notes_end == true
end

-- いちいちこれ書くのめんどいから 短縮コマンドを作成。
function next_l()
	bm_line_n = bm_line_n + 1
end

-- game_drawの時に 譜面の種類を読み込み
function jiro_beatmap_update()
	-- 処理する行を宣言
	local cache = data_line[bm_line_n]
	-- 切り出した文字を宣言
	local cache2 = 0
	-- 行の文字数
	-- local length = #cache
	
	-- テーブルに現在の行は 何個に分けられているかを追加する
	hit_bpm = bpm
	-- デフォルトで 文字を切り出す
	flag.add = true
	
	-- コマンドなら new_hitはコマンドに
		-- cacheが / または 空なら 行変更
		if cache == "/" or length == 0 then next_l() end
		-- cacheが , なら new_hit を RESTに
			-- 一拍休む
		if cache == "," then new_hit = "REST" flag.add = false next_l() end
		-- cacheが (#GOGOSTART) なら GOGOSTARTをnew_hitに追加
			-- 表示画像をkiaiにする
		if cache == "#GOGOSTART" then new_hit = "GOSTART" kiai = 1 flag.add = false next_l() end
		-- cacheが (#GOGOEND) なら GOGOENDをnew_hitに追加
			-- 表示画像をnormalにする
		if cache == "#GOGOEND" then new_hit = "GOEND" kiai = 0 flag.add = false next_l() end
		-- cacheが (END) なら ENDをnew_hitに追加
			--これになってたら game_update側の処理で 譜面を終了する(status="result")
			-- flag.end でもいいけど 処理短縮で new_hit を使いまわし。
		if cache == "#EN" or cache == "#END" then new_hit = "END" flag.add = false next_l() end
		
	-- 数字なら new_hitは数字を切り出す
	if flag.add == true then
		--追加する文字は num_num番目
		num_num = cnt[4]
		--cacheから num_num番目を切り抜く
		local cache2 = string.sub(cache, num_num, num_num)
		--行末記号であるかないか
		if cache2 ~= "," then
			new_hit = cache2
		else
			next_l()
			cnt[4] = 0
		end
	end
	
	
end