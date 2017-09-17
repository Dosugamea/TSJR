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
	
	line_max = table.maxn(data_line)
	
	--音符数をテーブルに記録
	repeat
		-- 現在の行のデータを読み込む
		local note_cache = data_line[bm_line_n]
		local note_length = #note_cache
		local comment_r = string.find(note_cache, "/")
		local comment2_r = string.sub(note_cache, 1, 1)

		-- とりあえず音符として数える(文字によって音符であるかないかを変える)
		notes = true
		-- データが一致または含まれれば それは音符ではない。 行を変える
		if comment2_r == "/" then notes = false end --コメント行のデータはデータなし。
		if note_cache == "," then wait_notes[notes_cnt] = "max" notes = false end --その行は 全音符
		if note_cache == "#GOGOSTART" then wait_notes[notes_cnt] = "GOSTART" notes = false end --コマンド gostart
		if note_cache == "#GOGOEND" then wait_notes[notes_cnt] = "GOEND" notes = false end --コマンド goend
		if note_cache == "#EN" or note_cache == "#END" then wait_notes[notes_cnt] = "END" notes_end = true end --コマンド end
		if notes == true then
			--コメントが行に含まれている場合
			if comment_r ~= nil then
				--1文字目から開始
				line_n = 1
				repeat
					--cm_numは line_n文字目
					cm_num = string.sub(note_cache, line_n, line_n)
					--もし cm_numが "," であれば comments_end をtrueにしてループを終了して 現在の行のwait_noteは line_n文字まで(数)
					if cm_num == "," then comments_end = true wait_notes[notes_cnt] = line_n - 1 end
					line_n = line_n + 1
				until comments_end == true
			else
				if note_length == 0 then
					wait_notes[notes_cnt] = "F"
				else
					wait_notes[notes_cnt] = note_length - 1
				end
			end
		end
		
		notes_cnt = notes_cnt + 1
		next_l()
	until notes_end == true
	
	bm_line_n = start_line[4] + 1  -- スタート地点一覧からcourse_line に一番近い番号 今回は強制的にEasyの行から開始

end

-- game_drawの時に 譜面の種類を読み込み
function jiro_beatmap_update()
	old_cnt = hit_cnt - 1
	--現在の行の数字が nilなら行をごり押しで変えるチート。
	yes_nil = false
	-- nilであればnilではない行まで+1するループ突入
	if wait_notes[debug_cnt] == nil then yes_nil = true end
	-- nilであれば 行変え→nilかどうか確認
	while yes_nil == true do
		debug_cnt = debug_cnt + 1
		if wait_notes[debug_cnt] ~= nil then yes_nil = false end
	end

	
	-- 処理する行の文字を宣言
	cache = data_line[bm_line_n]
	--1拍の文字数は 予めテーブルに取り出した文字数(とりあえずcnt[8]番目を指定)
	-- beat_1 = wait_notes[now_l]
	-- 一拍にかかる時間(1行の処理にかかる時間)
	beat_time = 60 / bpm
	-- 音符1つにかかる時間(1文字の処理にかかる時間)
	-- wait_time = beat_time / beat_1
	wait_time = 0.3
	
	-- デフォルトで 文字を切り出す
	if hit_cnt > old_cnt then
	flag.add = true
	end
	
	local comment_r = string.find(cache, "/")
	local length = #cache
	-- コマンドなら new_hitはコマンドに
		-- cacheが / または 空なら 行変更
		if comment_r ~= nil or length == 0 then flag.add = false hit_cnt = 1 next_l() end
		-- cacheが , なら new_hit を RESTに
			-- 一拍休む
		if cache == "," then new_hit = "REST" flag.add = false next_l() hit_cnt = 1 end
		-- cacheが (#GOGOSTART) なら GOGOSTARTをnew_hitに
			-- 表示画像をkiaiにする
		if cache == "#GOGOSTART" then new_hit = "GOSTART" kiai = 1 flag.add = false next_l() hit_cnt = 1 end
		-- cacheが (#GOGOEND) なら GOGOENDをnew_hitに
			-- 表示画像をnormalにする
		if cache == "#GOGOEND" then new_hit = "GOEND" kiai = 0 flag.add = false next_l() hit_cnt = 1 end
		-- cacheが (END) なら ENDをnew_hitに追加
			--これになってたら game_update側の処理で 譜面を終了する(status="result")
			-- flag.end でもいいけど 処理短縮で new_hit を使いまわし。
		if cache == "#EN" or cache == "#END" then new_hit = "END" flag.add = false next_l() hit_cnt = 1 end
		
	-- 数字なら new_hitは数字を切り出す
	if flag.add == true then
		--cacheから num_num番目を切り抜く
		local cache2 = string.sub(cache, hit_cnt, hit_cnt)
		--行末記号であるかないか
		if cache2 ~= "," then
			new_hit = cache2
		else
			next_l()
			hit_cnt = 1
			debug_cnt = debug_cnt + 1
		end
	end
	
	-- 事前に計算した 1音符にかかる処理時間経過したら次の文字に変更
	if timer > old_timer + wait_time then
		hit_cnt = hit_cnt + 1 --切り出す文字を変更
		-- table.insert(hit_table, new_hit) --画面上に表示する譜面にnew_hitを代入
		-- hit_table_x[hits_cnt] = 0 --画面上での開始位置
		old_timer = timer -- 以前のタイマーの値は今のタイマーの値
	end
end