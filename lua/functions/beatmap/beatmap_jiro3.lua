function jiro_beatmap_var()
	--�e�t���O�̐錾 �� �f�o�b�O�p
	
	course_l = course_line[4] --�@�R�[�X�ꗗ����w�肵���ԍ��̍s�ԍ����擾 ����͋��� Easy
	level_l = level_line[4] --���x���ꗗ����w�肵���ԍ� ����͋���3
	bm_line_n = start_line[4] + 1  -- �X�^�[�g�n�_�ꗗ����course_line �Ɉ�ԋ߂��ԍ� ����͋����I��Easy�̍s����J�n
	wait_notes = {} -- �e�s�̉�������ۑ�����e�[�u��
	notes = true -- ���̍s�͐����ł��邩�A�̃t���O
	notes_end = false
	
	level = string.sub(data_line[level_l], 7) -- ���x���̐����؂�o��
	course = string.sub(data_line[course_l], 8) -- �R�[�X�̖��̂̐؂�o��	
	
	
	
	-- ���������e�[�u���ɋL�^
	-- repeat
		-- ���݂̍s�̃f�[�^��ǂݍ���
		-- local cache = data_line[bm_line_n]
		-- �Ƃ肠���������Ƃ��Đ�����(�����ɂ���ĉ����ł��邩�Ȃ�����ς���)
		-- notes = true
		-- �f�[�^����v����� ����͉����ł͂Ȃ��B �s��ς���
		-- if cache == "/" or length == 0 then wait_notes[cnt[6]] = nil end
		-- if cache == "," then wait_notes[cnt[6]] = "max" end
		-- if cache == "#GOGOSTART" then end
		-- if cache == "#GOGOEND" then end
		-- if cache == "#EN" or cache == "#END" then notes_end = true end
	
		-- if notes ~= true then end
		-- next_l()
	-- until notes_end == true
end

-- �����������ꏑ���̂߂�ǂ����� �Z�k�R�}���h���쐬�B
function next_l()
	bm_line_n = bm_line_n + 1
end

-- game_draw�̎��� ���ʂ̎�ނ�ǂݍ���
function jiro_beatmap_update()
	-- ��������s��錾
	local cache = data_line[bm_line_n]
	-- �؂�o����������錾
	local cache2 = 0
	-- �s�̕�����
	-- local length = #cache
	
	-- �e�[�u���Ɍ��݂̍s�� ���ɕ������Ă��邩��ǉ�����
	hit_bpm = bpm
	-- �f�t�H���g�� ������؂�o��
	flag.add = true
	
	-- �R�}���h�Ȃ� new_hit�̓R�}���h��
		-- cache�� / �܂��� ��Ȃ� �s�ύX
		if cache == "/" or length == 0 then next_l() end
		-- cache�� , �Ȃ� new_hit �� REST��
			-- �ꔏ�x��
		if cache == "," then new_hit = "REST" flag.add = false next_l() end
		-- cache�� (#GOGOSTART) �Ȃ� GOGOSTART��new_hit�ɒǉ�
			-- �\���摜��kiai�ɂ���
		if cache == "#GOGOSTART" then new_hit = "GOSTART" kiai = 1 flag.add = false next_l() end
		-- cache�� (#GOGOEND) �Ȃ� GOGOEND��new_hit�ɒǉ�
			-- �\���摜��normal�ɂ���
		if cache == "#GOGOEND" then new_hit = "GOEND" kiai = 0 flag.add = false next_l() end
		-- cache�� (END) �Ȃ� END��new_hit�ɒǉ�
			--����ɂȂ��Ă��� game_update���̏����� ���ʂ��I������(status="result")
			-- flag.end �ł��������� �����Z�k�� new_hit ���g���܂킵�B
		if cache == "#EN" or cache == "#END" then new_hit = "END" flag.add = false next_l() end
		
	-- �����Ȃ� new_hit�͐�����؂�o��
	if flag.add == true then
		--�ǉ����镶���� num_num�Ԗ�
		num_num = cnt[4]
		--cache���� num_num�Ԗڂ�؂蔲��
		local cache2 = string.sub(cache, num_num, num_num)
		--�s���L���ł��邩�Ȃ���
		if cache2 ~= "," then
			new_hit = cache2
		else
			next_l()
			cnt[4] = 0
		end
	end
	
	
end