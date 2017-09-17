-- いちいち bm_line_n = bm_line_n + 1 書くのめんどいから 短縮コマンドを作成。
function next_l()
	bm_line_n = bm_line_n + 1
end

--コマンド #BPMCHANGE(数値) が 飛んで来たら BPMCHANGE
function bgm_change()
	beat_time = 60 / bpm
end

function jiro_beatmap_var()
	--各フラグの宣言 兼 デバッグ用
	old_timer = 0 -- 一番はじめの旧時間は 丁度譜面を開始したタイミング	
	hit_table = {} -- 実際に画面に表示する譜面の数(種類)
	hit_table_x = {} -- 実際に画面に表示する譜面の座標(X軸)
	course_l = course_line[4] --　コース一覧から指定した番号の行番号を取得 今回は強制 Easy
	level_l = level_line[4] --レベル一覧から指定した番号 今回は強制3
	bm_line_n = start_line[4] + 1  -- スタート地点一覧からcourse_line に一番近い番号 今回は強制的にEasyの行から開始
	wait_notes = {} -- 各行の音符数を保存するテーブル
	notes = true -- この行は数字であるか、のフラグ
	notes_end = false -- 音符数記録 ループの終了フラグ
	comments_end = false --コメント用の現在の文字数
	level = string.sub(data_line[level_l], 7) -- レベルの数字切り出し
	course = string.sub(data_line[course_l], 8) -- コースの名称の切り出し
	old_cnt = 0
	note_length = 0
	flag.nx_l = true
	old_timer_pippi = 0
end

-- game_drawの時に 譜面の種類を読み込み
function jiro_beatmap_update()
	-- 通り過ぎたやつの 削除完了フラグ
	flag.delete_end = false

	--nil対策
	
	-- デフォルトで 文字を切り出す
	if hit_cnt > old_cnt then
		flag.add = true
	end
	
	if hit_cnt > old_cnt and new_hit == "GOSTART" then
		hit_cnt = 1
		next_l()
		old_cnt = hit_cnt
	end

	if hit_cnt > old_cnt and new_hit == "GOEND" then
		hit_cnt = 1
		next_l()
		old_cnt = hit_cnt
	end
	
	if hit_cnt > old_cnt and new_hit == "NEXT" then
		hit_cnt = 1
		next_l()
		old_cnt = hit_cnt
	end
	
	if hit_cnt > old_cnt and new_hit == "REST" then
		if data_line[bm_line_n + 1] == "#GOGOSTART" then hit_cnt = 0 else hit_cnt = 1 end
		next_l()
		old_cnt = hit_cnt
	end

	-- 処理する行の文字を宣言
	cache = data_line[bm_line_n]
	
	
	local comment_r = string.find(cache, "/")
	local length = #cache
	-- コマンドなら new_hitはコマンドに
		-- cacheが / または 空なら 行変更
		if comment_r ~= nil or length == 0 then new_hit = "NEXT" note_length = 0 flag.add = false hit_cnt = 1 old_cnt = hit_cnt end
		-- cacheが , なら new_hit を RESTに
			-- 一拍休む
		if cache == "," then new_hit = "REST" note_length = 0 flag.add = false old_cnt = hit_cnt hit_cnt = 1 end
		-- cacheが (#GOGOSTART) なら GOGOSTARTをnew_hitに
			-- 表示画像をkiaiにする
		if cache == "#GOGOSTART" then new_hit = "GOSTART" note_length = 0 kiai = 1 flag.add = false old_cnt = hit_cnt hit_cnt = 1 end
		-- cacheが (#GOGOEND) なら GOGOENDをnew_hitに
			-- 表示画像をnormalにする
		if cache == "#GOGOEND" then new_hit = "GOEND" note_length = 0 kiai = 0 flag.add = false old_cnt = hit_cnt hit_cnt = 1 end
		-- cacheが (END) なら ENDをnew_hitに追加
			--これになってたら game_update側の処理で 譜面を終了する(status="result")
			-- flag.end でもいいけど 処理短縮で new_hit を使いまわし。
		if cache == "#EN" or cache == "#END" then new_hit = "END" note_length = 0 flag.add = false end

	-- 数字なら new_hitは数字を切り出す
	if flag.add == true then
		--cacheから num_num番目を切り抜く
		local cache2 = string.sub(cache, hit_cnt, hit_cnt)
		--行末記号であるかないか
		if cache2 ~= "," then
			note_length = #cache - 1
			new_hit = cache2
		else
			next_l()
			hit_cnt = 1
			old_cnt = hit_cnt
		end
	end
	
	-- 一拍にかかる時間(1行の処理にかかる時間)
	beat_time = 60 / bpm * 4
 	
	-- 音符1つにかかる時間(1文字の処理にかかる時間)
	if note_length ~= 0 then
	wait_time = beat_time / note_length
	else
		if new_hit == "REST" then wait_time = beat_time else wait_time = 0.0000001 end
	end
	
	-- 事前に計算した 1音符にかかる処理時間経過したら次の文字に変更
	if timer > old_timer + wait_time and new_hit ~= "END" then
		hit_cnt = hit_cnt + 1 --切り出す文字を変更
		
		if new_hit ~= "NEXT" and new_hit ~= "REST" and new_hit ~= "GOSTART" and new_hit ~= "GOEND" and new_hit ~= "GOEND" and new_hit ~= 0 then
			table.insert(hit_table, new_hit)
		end
		
		old_timer = timer -- 以前のタイマーの値は今のタイマーの値
	end
end