function var()
	-- まず変数を宣言
	pippidon = {}
	hit = {}
	slider = {}
	scorebar = {}
	mainbar = {}
	t_mod = {}
	background = {}
	bottom = {}
	flag = {}
	donSound = {}
	kaSound = {}
	data_line = {}
	
	timer = 0
	
	beatmap_type1 = 0
	beatmap_type2 = 0
	
	local count
	-- とりあえず ドン を 10個読み込み
	for count=0, 0 do
	donSound[count] = love.audio.newSource('themes/Taiko_AC0_v4_resize/normal-hitnormal.wav')
	count = count + 1
	end
	-- とりあえず カ を 10個読み込み
	for count=0, 0 do
	kaSound[count] = love.audio.newSource('themes/Taiko_AC0_v4_resize/normal-hitclap.wav')
	count = count + 1
	end
	
	--検証用、とりあえず次郎のスキンの背景読み込み
	-- bg = love.graphics.newImage('system/bg.png')
	
	--画像読み込み
	score_0 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-0.png')
	score_1 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-1.png')
	score_2 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-2.png')
	score_3	= love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-3.png')
	score_4 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-4.png')
	score_5 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-5.png')
	score_6 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-6.png')
	score_7 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-7.png')
	score_8 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-8.png')
	score_9 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/score-9.png')	
	don_img = love.graphics.newImage('themes/Taiko_AC0_v4_resize/hit_don.png')
	ka_img = love.graphics.newImage('themes/Taiko_AC0_v4_resize/hit_ka.png')
	don_big_img = love.graphics.newImage('themes/Taiko_AC0_v4_resize/hit_big_don.png')
	ka_big_img = love.graphics.newImage('themes/Taiko_AC0_v4_resize/hit_big_ka.png')
	hit_timing_img = love.graphics.newImage('themes/Taiko_AC0_v4_resize/approachcircle.png')
	bottom.taiko = love.graphics.newImage('system/Osu_Taiko_Bottom.png')
	hit.donimg = love.graphics.newImage('themes/Taiko_AC0_v4_resize/taiko-drum-inner.png')
	hit.kaimg = love.graphics.newImage('themes/Taiko_AC0_v4_resize/taiko-drum-outer.png')
	pippidon.idle0 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/pippidonidle0.png')
	pippidon.idle1 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/pippidonidle1.png')
	pippidon.idle2 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/pippidonidle2.png')
	pippidon.idle3 = love.graphics.newImage('themes/Taiko_AC0_v4_resize/pippidonidle3.png')
	scorebar = love.graphics.newImage('themes/Taiko_AC0_v4_resize/scorebar-bg.png')
	scorebar_c = love.graphics.newImage('themes/Taiko_AC0_v4_resize/scorebar-colour.png')
	mainbar.taiko = love.graphics.newImage('themes/Taiko_AC0_v4_resize/taiko-bar-left2.png')
	mainbar.normal = love.graphics.newImage('themes/Taiko_AC0_v4_resize/taiko-bar-right2.png')
	mainbar.kiai = love.graphics.newImage('themes/Taiko_AC0_v4_resize/taiko-bar-right-glow.png')
	background.playfield = love.graphics.newImage('themes/Taiko_AC0_v4_resize/playfield.png')
	background.slider = love.graphics.newImage('themes/Taiko_AC0_v4_resize/taiko-slider.png')
	
	--座標と時間とflagを宣言
	kiai = 0
	bottom.taiko_Y = 0
	background.sliderX = 0
	background.sliderY = 0
	background.slider2X = 400
	background.slider2Y = 0
	pippidon.anim = 0
	noSound = false
	noBGM = false
	status = "ready"
	select = 1
	
	-- ドンとカッ Table
	timer = 0
	hit_don = {}
	hit.don = 0
	hit_ka = {}
	hit.ka = 0
	playing_don = {}
	playing_ka = {}
	search = {0,0,0}
	endpoint = {0,0,0}
	
	--
	
	--音符数を保存するテーブル用 何番目の要素に代入するか
	notes_cnt = 0
	--音符数を保存するテーブル用　行を変えるかどうかのフラグ
	flag.notes = true
	
	--サブタイトルの上下アニメーション用
	sub_title_cnt = 0
	--下画面太鼓の上下アニメーション用
	taiko_updown_cnt = 0
	--ピッピドンのアニメーション用
	pippidon_anim_cnt = 0
	--new_hit用 空行やコマンドが来た場合に行が変わらなくて詰むことがないようにする対策
	hit_cnt = 1
	-- ゲーム中の現在の行数(bm_line_nから分離する)
	load_l_cnt = 1
	--デバッグ用 ボタンを押す度に値が1上がる
	debug_cnt = 0
	
	--タコは上下アニメーション中なのかどうか
	flag.taiko = false
	
	--それぞれ同じ譜面内に何個あっても対応できるようにテーブル化
	start_line = {}
	end_line = {}
	level_line = {}
	course_line = {}
	
	-- 下画面太鼓XY計算用変数宣言
	touchX = 0
	touchY = 0
	r_a = 7000
	
	-- デバッグメッセージフラグ宣言
	flag.var = true
end