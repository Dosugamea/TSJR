function var()
	-- �܂��ϐ���錾
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
	-- �Ƃ肠���� �h�� �� 10�ǂݍ���
	for count=0, 0 do
	donSound[count] = love.audio.newSource('themes/Taiko_AC0_v4_resize/normal-hitnormal.wav')
	count = count + 1
	end
	-- �Ƃ肠���� �J �� 10�ǂݍ���
	for count=0, 0 do
	kaSound[count] = love.audio.newSource('themes/Taiko_AC0_v4_resize/normal-hitclap.wav')
	count = count + 1
	end
	
	--���ؗp�A�Ƃ肠�������Y�̃X�L���̔w�i�ǂݍ���
	-- bg = love.graphics.newImage('system/bg.png')
	
	--�摜�ǂݍ���
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
	
	--���W�Ǝ��Ԃ�flag��錾
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
	
	-- �h���ƃJ�b Table
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
	
	--��������ۑ�����e�[�u���p ���Ԗڂ̗v�f�ɑ�����邩
	notes_cnt = 0
	--��������ۑ�����e�[�u���p�@�s��ς��邩�ǂ����̃t���O
	flag.notes = true
	
	--�T�u�^�C�g���̏㉺�A�j���[�V�����p
	sub_title_cnt = 0
	--����ʑ��ۂ̏㉺�A�j���[�V�����p
	taiko_updown_cnt = 0
	--�s�b�s�h���̃A�j���[�V�����p
	pippidon_anim_cnt = 0
	--new_hit�p ��s��R�}���h�������ꍇ�ɍs���ς��Ȃ��ċl�ނ��Ƃ��Ȃ��悤�ɂ���΍�
	hit_cnt = 1
	-- �Q�[�����̌��݂̍s��(bm_line_n���番������)
	load_l_cnt = 1
	--�f�o�b�O�p �{�^���������x�ɒl��1�オ��
	debug_cnt = 0
	
	--�^�R�͏㉺�A�j���[�V�������Ȃ̂��ǂ���
	flag.taiko = false
	
	--���ꂼ�ꓯ�����ʓ��ɉ������Ă��Ή��ł���悤�Ƀe�[�u����
	start_line = {}
	end_line = {}
	level_line = {}
	course_line = {}
	
	-- ����ʑ���XY�v�Z�p�ϐ��錾
	touchX = 0
	touchY = 0
	r_a = 7000
	
	-- �f�o�b�O���b�Z�[�W�t���O�錾
	flag.var = true
end