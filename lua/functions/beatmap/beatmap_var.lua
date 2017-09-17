function beatmap_var()
	-- filepath = "songs/debug.txt"
	filepath = "songs/Jiro/Hanamaru Pippi ha yoiko dake.tja"
	-- filepath = "songs/Osu/Gakkou_gurashi/Gakuen Seikatsu Bu - Friend Shitai (aabc271) [Futsuu].osu"
	file, msg = io.open(filepath, "r")
	search_l = 0
	bgm = love.audio.newSource("songs/Jiro/Hanamaru_Pippi_ha_yoiko_dake.wav")
	
	-- �Ȃ̃f�t�H���g�p�����[�^
	song_name = "Unknown"
	song_sub_name = "No there a artist."
	subnameX = 220
	subnameY = 141
	
	-- �Ȃ�ƂȂ����[�J���ϐ��Ő錾���Ƃ�
	local l = {1,1,1,1}
	-- f:lines�ň�s���e�L�X�g�t�@�C����ǂݍ���
	for line in file:lines() do	
		search_l = search_l + 1
		-- line(���������s) �� data_line[�Ή�����s��] �ɑ��
		local length = #line
		line = string.sub(line, 0, length - 1)
		data_line[search_l] = line
		-- length�͌������̕��̒���
		-- �������̍s������
		-- ���ꂼ��@�������������ʂ���(�Ō�Ɍ��������s�̒l����������)
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
			--�e�[�u���� LEVEL: �̌��������ʒu�������o��
			level_line[l[1]] = search_l
			l[1] = l[1] + 1
			flag.level = true
		end
		
		if course_r ~= nil then
			--�e�[�u���� COURSE: �̌��������ʒu�������o��
			course_line[l[2]] = search_l
			l[2] = l[2] + 1
			flag.course = true
		end
		
		if title_r ~= nil then
			-- title_r�ɉ����l�������Ă���(�܂� Osu�����Ƀq�b�g�����ꍇ)
			song_name = string.sub(data_line[search_l], 7, length)
			-- �������̕��� 7������(Title:�폜)����
			-- �������̕��̍Ō�܂ł��Ȗ��ɑ������
			flag.title_osu = true
		end
		
		if subtitle_r ~= nil then
			local length = #data_line[search_l - 1]
			-- subtitle_r�ɉ����l�������Ă���(�܂� Jiro�����Ƀq�b�g�����ꍇ)
			song_name = string.sub(data_line[search_l - 1], 7, length)
			-- �������̕��� 7������(Title:�폜)����
			-- �������̕��̍Ō�܂ł��Ȗ��ɑ������
			flag.subtitle_jiro = true
		end
		
		if artist_r ~= nil then
			-- artist_r�ɉ����l�������Ă���(�܂茟���Ƀq�b�g�����ꍇ)
			song_sub_name = string.sub(data_line[search_l], 8, length)
			-- �������̕��� 7������(Title:�폜)����
			-- �������̕��̍Ō�܂ł��Ȗ��ɑ������
			flag.artist = true
		end
	
		if timingpoints_r ~= nil then
			-- timingpoints_r�ɉ����l�������Ă���(�܂茟���Ƀq�b�g�����ꍇ)
			-- �^�C�~���O�|�C���g�𔭌������s���� search[1]�ɓ˂�����
			search[1] = search_l
			flag.timingpoints = true
		end
	
		if hitobjects_r ~= nil then
		-- hitobjects_r�ɉ����l�������Ă���(�܂茟���Ƀq�b�g�����ꍇ)
		-- �q�b�g�I�u�W�F�N�g�𔭌������s���� search[1]�ɓ˂�����
			search[2] = search_l
			flag.hitobjects = true
		end
		
		if bpm_r ~= nil then
			bpm = string.sub(data_line[search_l], 5, length)
			flag.bpm = true
		end
		
		if beatmap_type1 ~= nil then
			--�e�[�u���� #START �̌��������ʒu�������o��
			start_line[l[3]] = search_l
			l[3] = l[3] + 1
			mode = "jiro"
			flag.mode = true
		end
		
		if beatmap_type2 ~= nil then mode = "osu" flag.mode = true end		
	
		if end_r ~= nil then
			--�e�[�u���� #END �̌��������ʒu�������o��
			end_line[l[4]] = search_l
			l[4] = l[4] + 1
			flag.mode = true
		end
		
	end
	
	file:close ()
	
	--�����܂ł� ��Փx�ƕ��ʂ̊J�n�ʒu�����o������
	if mode == "jiro" then jiro_beatmap_var() end
	if mode == "osu" then osu_beatmap_var() end
	

	-- �T�u�^�C�g���̕\���t���O
	flag.sub_title = true
	search_end = true
	
end