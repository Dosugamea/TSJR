-- いちいちこれ書くのめんどいから 短縮コマンドを作成。
function next_l()
	bm_line_n = bm_line_n + 1
end

function jiro_beatmap_var()
	--各フラグの宣言 兼 デバッグ用
	
	course_l = course_line[4] --　コース一覧から指定した番号の行番号を取得 今回は強制 Easy
	level_l = level_line[4] --レベル一覧から指定した番号 今回は強制3
	bm_line_n = start_line[4] + 1  -- スタート地点一覧からcourse_line に一番近い番号 今回は強制的にEasyの行から開始
	wait_notes = {} -- 各行の音符数を保存するテーブル
	notes = true -- この行は数字であるか、のフラグ
	notes_end = false -- 音符数記録 ループの終了フラグ
	comments_end = false --コメント用の現在の文字数
	level = string.sub(data_line[level_l], 7) -- レベルの数字切り出し
	course = string.sub(data_line[course_l], 8) -- コースの名称の切り出し
	
	line_max = table.maxn(data_line)
	
	--音符数をテーブルに記録
	repeat
		-- 現在の行のデータを読み込む
		local note_cache = data_line[bm_line_n]
		local note_length = #note_cache
		local comment_r = string.find(note_cache, "/")
		-- とりあえず音符として数える(文字によって音符であるかないかを変える)
		notes = true
		-- データが一致すれば それは音符ではない。 行を変える
		if note_cache == "/" then wait_notes[cnt[6]] = nil notes = false end --その行のデータはデータなし。
		if note_cache == "," then wait_notes[cnt[6]] = "max" notes = false end --その行は 全音符
		if note_cache == "#GOGOSTART" then wait_notes[cnt[6]] = "GOSTART" notes = false end --コマンド gostart
		if note_cache == "#GOGOEND" then wait_notes[cnt[6]] = "GOEND" notes = false end --コマンド goend
		if note_cache == "#EN" or note_cache == "#END" then wait_notes[cnt[6]] = "END" notes_end = true end --コマンド end
		if notes == true then
			--コメントが行に含まれている場合
			if comment_r ~= nil then
				--1文字目から開始
				line_n = 0
				repeat
					line_n = line_n + 1
					--cm_numは line_n文字目
					cm_num = string.sub(note_cache, line_n, line_n)
					--もし cm_numが "," であれば comments_end をtrueにしてループを終了して 現在の行のwait_noteは line_n文字まで(数)
					if cm_num == "," then comments_end = true wait_notes[cnt[6]] = line_n - 1 end
				until comments_end == true
			else
			wait_notes[cnt[6]] = note_length - 1
			end
		end
		
		if wait_notes[cnt[6]] == -1 then wait_notes[cnt[6]] = 0 end -- 何もない行はごり押しで0にする
		next_l()
		cnt[6] = cnt[6] + 1
	until notes_end == true
	
	bm_line_n = start_line[4] + 1  -- スタート地点一覧からcourse_line に一番近い番号 今回は強制的にEasyの行から開始
	
end

-- game_drawの時に 譜面の種類を読み込み
function jiro_beatmap_update()
	-- 処理する行を宣言
	cache = data_line[bm_line_n]
	
	-- デフォルトで 文字を切り出す
	flag.add = true
	
	-- コマンドなら new_hitはコマンドに
		-- cacheが / または 空なら 行変更
		if cache == "/" or length == 0 then bm_line_n = bm_line_n + 1 end
		-- cacheが , なら new_hit を RESTに
			-- 一拍休む
		if cache == "," then new_hit = "REST" flag.add = false bm_line_n = bm_line_n + 1 end
		-- cacheが (#GOGOSTART) なら GOGOSTARTをnew_hitに追加
			-- 表示画像をkiaiにする
		if cache == "#GOGOSTART" then new_hit = "GOSTART" kiai = 1 flag.add = false bm_line_n = bm_line_n + 1 end
		-- cacheが (#GOGOEND) なら GOGOENDをnew_hitに追加
			-- 表示画像をnormalにする
		if cache == "#GOGOEND" then new_hit = "GOEND" kiai = 0 flag.add = false bm_line_n = bm_line_n + 1 end
		-- cacheが (END) なら ENDをnew_hitに追加
			--これになってたら game_update側の処理で 譜面を終了する(status="result")
			-- flag.end でもいいけど 処理短縮で new_hit を使いまわし。
		if cache == "#EN" or cache == "#END" then new_hit = "END" flag.add = false bm_line_n = bm_line_n + 1 end
		
	-- 数字なら new_hitは数字を切り出す
	if flag.add == true then
		--追加する文字は num_num番目
		num_num = cnt[4]
		--cacheから num_num番目を切り抜く
		cache2 = string.sub(cache, num_num, num_num)
		--行末記号であるかないか
		if cache2 ~= "," then
			new_hit = cache2
		else
			bm_line_n = bm_line_n + 1
			-- cnt[4] = 0
		end
	end
	
	
end