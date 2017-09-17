-- ToDo.
-- 正常に切り出せるようにしろおおおおおおお!!!!
-- #GOGOSTART と #GOGOEND と #END と #BPMCHANGE と 分岐譜面 の 処理はどこ?

function jiro_beatmap_var()
	--各フラグの宣言 兼 デバッグ用
	var_end = true
	flag.add = true
	add_end = true
	bm_line_n = 0
	extract = 0
	extract_num = 0
	ex_num_add = 0
	
	course_l = course_line[4] --　コース一覧から指定した番号の行番号を取得 今回は強制 Easy
	level_l = level_line[4] --レベル一覧から指定した番号 今回は強制3
	bm_line_n = start_line[4] + 1 -- スタート地点一覧からcourse_line に一番近い番号 今回は強制的にEasyの行から開始
	
	level = string.sub(data_line[level_l], 7) -- レベルの数字切り出し
	course = string.sub(data_line[course_l], 8) -- コースの名称の切り出し

	
	-- 各行に書いてある譜面を実行するテーブルに変換する
	
	-- #ENDが発見されるまでループを繰り返す
	while var_end == false do
			-- 文字を分解して追加するかのフラグ
		flag.add = true
		-- new_hit_tableの何番目の要素か
		cnt[5] = cnt[5] + 1

		local length = #data_line[bm_line_n]
		-- 処理中の文字の長さ

		-- data_line[bm_line_n]が (#GOGOSTART) なら GOGOSTARTをnew_hitに追加
		if data_line[bm_line_n] == "#GOGOSTART" then new_hit[cnt[5]] = "GOGOSTART" flag.add = false end	
		-- data_line[bm_line_n]が (#GOGOEND) なら GOGOENDをnew_hitに追加
		if data_line[bm_line_n] == "#GOGOEND" then new_hit[cnt[5]] = "GOGOEND" flag.add = false end
		-- data_line[bm_line_n]が (END) なら ENDをnew_hitに追加 して 成型終了
		if data_line[bm_line_n] == "#EN" or data_line[bm_line_n] == "#END" then new_hit[cnt[5]] = "END" flag.add = false var_end = true end
		
		-- / が見つかったら、または行が空なら。 追加せずに次の行へ
		if data_line[bm_line_n] == "/" or length == 0 then flag.add = false end
		-- , が見つかったら。	 1拍休みを追加して次の行へ
		if data_line[bm_line_n] == "," then new_hit[cnt[5]] = "REST" flag.add = false end
		
		bm_line_n = bm_line_n + 1

		
		-- 今までのステップで弾かれなかった 数字の行であれば
		if flag.add == true then
			-- 行追加ループ開始
			-- 行の文字数が1になるまで繰り返す
			extract_num = data_line[bm_line_n]
			local length = #extract_num - 1
			
				-- 現在の行は　現在の行の2文字目から最後の文字まで
				extract_num = string.sub(extract_num, 2)
				-- 追加する文字は 現在の行の 1文字目
				ex_num_add = string.sub(extract_num, 1, 1)
				new_hit[cnt[5]] = ex_num_add
				cnt[5] = cnt[5] + 1
			add_end = true
			bm_line_n = bm_line_n + 1
			flag.add = false
		end
	end
end