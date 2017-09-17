--メモ

-- love.update(dt) は　毎フレーム呼び出されます, 
-- 基本的にはゲームロジックに使用されます。
-- この dt 引数 は フレーム間の平均時間、デルタタイムです
--  (デルタタイム=前のフレームと今のフレームの時間的な差分)
-- ゲームのフレームレートに依存しないようにするためには これを使ってください
　 
-- love.draw() 毎フレーム毎に呼び出されます。
-- 画面の書き換えは全てここに記述してください。

-- love.keypressed は 何らかのボタンが押されたときに呼び出されます
-- key という引数は 押されたボタンです。
-- ボタンが一番最後まで押されている状態を取得したい場合、全てのインプットコードをここに書かないでください。
-- love.update(dt) とともに love.keyboard.isDown() を用いてください

-- love.quit は LovePotion の終了中に呼び出されます
-- クリーンアップコードなどはここに書き込んでください。


-- local = 実行中のfunction内のみで定義する
-- (function外で使われる実際の変数は維持されたまま)

-- font = love.graphics.newFont()
-- 新しいフォントを定義, 引数なしでデフォルトフォントを使用。


-- love.graphics.setScreen('bottom')
-- 操作する画面を指定する (この場合 上画面)
-- 再度この命令が呼び出されて変更されるまで有効

-- love.graphics.newImage('')
-- 特定パスからファイルの読み込み

--love.graphics.getWidth()/getHeight() および Image:getWidth()/getHeight()
-- 画面サイズ/画像サイズの取得



-- 古いコード
-- どこに使おうとしたんだったっ気かなあ
	if mode == "jiro" then
		local table_max = table.maxn(data_line)
		local l = 1
		local r = 0
		local level_search = true

		while level_search == false do
			level = string.find(data_line[l], "LEVEL:")
			if level ~= nil then
				level_line[r] = l
				r = r + 1
			end
			l = l + 1
			
			if l == table.maxn then
				level_search = false
			end
		end
	end
	
	-- Level の 行数を基準に #START位置を探す
	-- 譜面データの開始行数を指定
	while search_end == false do
		--検索行変更
		cnt[5] = cnt[5] + 1
		--#STARTを検索
		start_r = string.find(data_line[cnt[5]], "#START")
		--見つかったら、 譜面本体の行は #STARTの行 + 1行目である。
		if start_r ~= nil then
			bm_line_n = cnt[5] + 1
			--start_r は見つかった。
			search_end = true
		end
	end

	
--	 Nightly 0130 より
	-- ロード時にループで data_line内の譜面を全分割する方法
	-- テーブルのメモリオーバーで没に

	-- #ENDが発見されるまでループを繰り返す
	while var_end == false do
			-- 文字を分解して追加するかのフラグ
		flag.add = true
		-- new_hit_tableの何番目の要素か
		bm_line_n = bm_line_n + 1
		cnt[5] = cnt[5] + 1
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

		if flag.add == true then add_word() end

	end
	
function add_word()
		-- 今までのステップで弾かれなかった 数字の行であれば
			-- 行追加ループ開始
			-- 行の文字数が1になるまで繰り返す
		local z = 0
		
		repeat
			-- 現在の行の文字取り出し
			z = z + 1
			word = string.sub(data_line[bm_line_n], z, z)

			-- もし cache が , なら 終了 
			if word == "," then
				add_end = true
				new_hit[cnt[5]] = ","
				cnt[5] = cnt[5] + 1
			else
				-- 普通の数字なら
				-- テーブルに 現在の行の1文字目を追加
				new_hit[cnt[5]] = word
				cnt[5] = cnt[5] + 1
			end

		until add_end == true
		cnt[5] = cnt[5] - 1
end


--最初の出現位置
-- hit_table_x = 395
--小さいサイズなら hit_table_x
--大きいサイズなら hit_table_x + 5

-- 判定位置
-- decision_p = 60
-- 小さいサイズなら decision_p
-- 大きいサイズなら decision_p - 5

-- 移動速度 = 出現位置 - 判定位置 / かかる時間

--座標基準で判定したらこんな感じ
if hit_table[1] < decision_p + 5 or hit_table[1] > decision_p - 5
	--良
else if hit_table[1] < decision_p + 10 or hit_table[1] > decision_p - 10
	--可
	else 　
	--不可
	end
end

--ノートの文字書き起こし
	-- 2/1

-- cnt[9] は 新しく画面に表示させる譜面のID
--BPMは事前に取り出したBPMで間違いない。
BPM = bpm
--1拍の文字数は 予めテーブルに取り出した文字数(とりあえずcnt[8]番目を指定)
beat_1 = wait_table[cnt[8]]
-- 一拍にかかる時間(1行の処理にかかる時間)
beat_time = 60 / BPM
-- 音符1つにかかる時間(1文字の処理にかかる時間)
wait_time = beat_time / wait_table[cnt[8]]

--コマンド #BPMCHANGE(数値) が 飛んで来たら BPMCHANGE
function bgm_change()
	beat_time = 60 / bpm
end

function beatmap_var
	-- 一番はじめの旧時間は 丁度譜面を開始したタイミング
	old_timer = 0
	-- 実際に画面に表示する譜面の数(種類)
	hit_table = {}
	-- 実際に画面に表示する譜面の座標(X軸)
	hit_table_x = {}
end

function beatmap_jiro_update
	--new_hitが空なら次の行に進み、待機時間を再設定する
	if new_hit == "" then
		cnt[8] = cnt[8] + 1
		next_line() --譜面を次の行へ
		wait_time = beat_time / wait_table[cnt[8]] --待機時間設定
	end
	-- 以前のタイマーの値から、上記で設定した待機時間経過したら hit_tableにnew_hitを追加する。
	if timer > oldtimer + wait_time then
		hit_table[cnt[9]] = new_hit --画面上に表示する譜面にnew_hitを代入
		hit_table_x[cnt[9]] = 0 --画面上での開始位置
		old_timer = timer -- 以前のタイマーの値は今のタイマーの値
	end
	
	-- hit_table_xを全て動かす
	local n = 0
	repeat
		n = n + 1
		hit_table_x[n] = hit_table_x - move_x
	until n == table.maxn(hit_table)
	
	-- hit_tableとhit_table_xから 画面から通り過ぎたゴミを削除する
	-- どうしましょ
end

小ドン/カッ = 91
大ドン/カッ = 86


		-- new_hitが コマンドじゃなければ リストに追加
		if new_hit ~= "NEXT" and new_hit ~= "REST" and new_hit ~= "GOSTART" and new_hit ~= "GOEND" and new_hit ~= "GOEND" and new_hit ~= 0 then
			table.insert(hit_table, new_hit)
			-- 画面上に表示する譜面にnew_hitを代入
			if new_hit ~= 3 and new_hit ~= 4 and new_hit ~= 6 then
				table.insert(hit_table_x, 395)
				-- 画面上での開始位置を代入 (小さい奴の場合)
			else
				table.insert(hit_table_x, 400)
				-- 画面上での開始位置を代入 (でかい奴の場合)
			end
		end
		
		--繰り返す回数は hit_table_x の個数
		for_x_table = table.maxn(hit_table_x)
		
		-- n番目の 項目を 左に動かす
		for i=1, for_x_table do
			hit_table_x[i] = hit_table_x[i] - 3
		end
		