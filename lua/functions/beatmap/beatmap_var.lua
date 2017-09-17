function beatmap_var()
	-- filepath = "songs/debug.txt"
	filepath = "songs/Jiro/Hanamaru Pippi ha yoiko dake.tja"
	-- filepath = "songs/Osu/Gakkou_gurashi/Gakuen Seikatsu Bu - Friend Shitai (aabc271) [Futsuu].osu"
	file, msg = io.open(filepath, "r")
	search_l = 0
	bgm = love.audio.newSource("songs/Jiro/Hanamaru_Pippi_ha_yoiko_dake.wav")
	
	-- 曲のデフォルトパラメータ
	song_name = "Unknown"
	song_sub_name = "No there a artist."
	subnameX = 220
	subnameY = 141
	
	-- なんとなくローカル変数で宣言しとく
	local l = {1,1,1,1}
	-- f:linesで一行ずつテキストファイルを読み込む
	for line in file:lines() do	
		search_l = search_l + 1
		-- line(検査した行) を data_line[対応する行数] に代入
		local length = #line
		line = string.sub(line, 0, length - 1)
		data_line[search_l] = line
		-- lengthは検査中の文の長さ
		-- 検査中の行内から
		-- それぞれ　を検索した結果を代入(最後に見つかった行の値が代入される)
		local title_r = string.find(data_line[search_l], "Title:")
		local subtitle_r = string.find(data_line[search_l], "SUBTITLE:")
		local artist_r = string.find(data_line[search_l], "Artist:")
		local timingpoints_r = string.find(data_line[search_l], "[TimingPoints]")
		local hitobjects_r = string.find(data_line[search_l], "[HitObjects]")
		-- local searchend_r = string.find(data_line[search_l], "")
		local bpm_r = string.find(data_line[search_l], "BPM:")
		local beatmap_type1 = string.find(data_line[search_l], "#START")
		local beatmap_type2 = string.find(data_line[search_l], "osu file format")
		local end_r	= string.find(data_line[search_l], "#END")
		local level_r = string.find(data_line[search_l], "LEVEL:")
		local course_r = string.find(data_line[search_l], "COURSE:")
		
		if level_r ~= nil then
			--テーブルに LEVEL: の見つかった位置を書き出す
			level_line[l[1]] = search_l
			l[1] = l[1] + 1
			flag.level = true
		end
		
		if course_r ~= nil then
			--テーブルに COURSE: の見つかった位置を書き出す
			course_line[l[2]] = search_l
			l[2] = l[2] + 1
			flag.course = true
		end
		
		if title_r ~= nil then
			-- title_rに何か値が入っている(つまり Osu検索にヒットした場合)
			song_name = string.sub(data_line[search_l], 7, length)
			-- 検査中の文の 7文字目(Title:削除)から
			-- 検査中の文の最後までを曲名に代入する
			flag.title_osu = true
		end
		
		if subtitle_r ~= nil then
			local length = #data_line[search_l - 1]
			-- subtitle_rに何か値が入っている(つまり Jiro検索にヒットした場合)
			song_name = string.sub(data_line[search_l - 1], 7, length)
			-- 検査中の文の 7文字目(Title:削除)から
			-- 検査中の文の最後までを曲名に代入する
			flag.subtitle_jiro = true
		end
		
		if artist_r ~= nil then
			-- artist_rに何か値が入っている(つまり検索にヒットした場合)
			song_sub_name = string.sub(data_line[search_l], 8, length)
			-- 検査中の文の 7文字目(Title:削除)から
			-- 検査中の文の最後までを曲名に代入する
			flag.artist = true
		end
	
		if timingpoints_r ~= nil then
			-- timingpoints_rに何か値が入っている(つまり検索にヒットした場合)
			-- タイミングポイントを発見した行数を search[1]に突っ込む
			search[1] = search_l
			flag.timingpoints = true
		end
	
		if hitobjects_r ~= nil then
		-- hitobjects_rに何か値が入っている(つまり検索にヒットした場合)
		-- ヒットオブジェクトを発見した行数を search[1]に突っ込む
			search[2] = search_l
			flag.hitobjects = true
		end
		
		if bpm_r ~= nil then
			bpm = string.sub(data_line[search_l], 5, length)
			flag.bpm = true
		end
		
		if beatmap_type1 ~= nil then
			--テーブルに #START の見つかった位置を書き出す
			start_line[l[3]] = search_l
			l[3] = l[3] + 1
			mode = "jiro"
			flag.mode = true
		end
		
		if beatmap_type2 ~= nil then mode = "osu" flag.mode = true end		
	
		if end_r ~= nil then
			--テーブルに #END の見つかった位置を書き出す
			end_line[l[4]] = search_l
			l[4] = l[4] + 1
			flag.mode = true
		end
		
	end
	
	file:close ()
	
	--あくまでも 難易度と譜面の開始位置を取り出すだけ
	if mode == "jiro" then jiro_beatmap_var() end
	if mode == "osu" then osu_beatmap_var() end
	

	-- サブタイトルの表示フラグ
	flag.sub_title = true
	search_end = true
	
end