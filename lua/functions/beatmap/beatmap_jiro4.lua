-- �����������ꏑ���̂߂�ǂ����� �Z�k�R�}���h���쐬�B
function next_l()
	bm_line_n = bm_line_n + 1
end

function jiro_beatmap_var()
	--�e�t���O�̐錾 �� �f�o�b�O�p
	
	course_l = course_line[4] --�@�R�[�X�ꗗ����w�肵���ԍ��̍s�ԍ����擾 ����͋��� Easy
	level_l = level_line[4] --���x���ꗗ����w�肵���ԍ� ����͋���3
	bm_line_n = start_line[4] + 1  -- �X�^�[�g�n�_�ꗗ����course_line �Ɉ�ԋ߂��ԍ� ����͋����I��Easy�̍s����J�n
	wait_notes = {} -- �e�s�̉�������ۑ�����e�[�u��
	notes = true -- ���̍s�͐����ł��邩�A�̃t���O
	notes_end = false -- �������L�^ ���[�v�̏I���t���O
	comments_end = false --�R�����g�p�̌��݂̕�����
	level = string.sub(data_line[level_l], 7) -- ���x���̐����؂�o��
	course = string.sub(data_line[course_l], 8) -- �R�[�X�̖��̂̐؂�o��
	
	line_max = table.maxn(data_line)
	
	--���������e�[�u���ɋL�^
	repeat
		-- ���݂̍s�̃f�[�^��ǂݍ���
		local note_cache = data_line[bm_line_n]
		local note_length = #note_cache
		local comment_r = string.find(note_cache, "/")
		-- �Ƃ肠���������Ƃ��Đ�����(�����ɂ���ĉ����ł��邩�Ȃ�����ς���)
		notes = true
		-- �f�[�^����v����� ����͉����ł͂Ȃ��B �s��ς���
		if note_cache == "/" then wait_notes[cnt[6]] = nil notes = false end --���̍s�̃f�[�^�̓f�[�^�Ȃ��B
		if note_cache == "," then wait_notes[cnt[6]] = "max" notes = false end --���̍s�� �S����
		if note_cache == "#GOGOSTART" then wait_notes[cnt[6]] = "GOSTART" notes = false end --�R�}���h gostart
		if note_cache == "#GOGOEND" then wait_notes[cnt[6]] = "GOEND" notes = false end --�R�}���h goend
		if note_cache == "#EN" or note_cache == "#END" then wait_notes[cnt[6]] = "END" notes_end = true end --�R�}���h end
		if notes == true then
			--�R�����g���s�Ɋ܂܂�Ă���ꍇ
			if comment_r ~= nil then
				--1�����ڂ���J�n
				line_n = 0
				repeat
					line_n = line_n + 1
					--cm_num�� line_n������
					cm_num = string.sub(note_cache, line_n, line_n)
					--���� cm_num�� "," �ł���� comments_end ��true�ɂ��ă��[�v���I������ ���݂̍s��wait_note�� line_n�����܂�(��)
					if cm_num == "," then comments_end = true wait_notes[cnt[6]] = line_n - 1 end
				until comments_end == true
			else
			wait_notes[cnt[6]] = note_length - 1
			end
		end
		
		if wait_notes[cnt[6]] == -1 then wait_notes[cnt[6]] = 0 end -- �����Ȃ��s�͂��艟����0�ɂ���
		next_l()
		cnt[6] = cnt[6] + 1
	until notes_end == true
	
	bm_line_n = start_line[4] + 1  -- �X�^�[�g�n�_�ꗗ����course_line �Ɉ�ԋ߂��ԍ� ����͋����I��Easy�̍s����J�n
	
end

-- game_draw�̎��� ���ʂ̎�ނ�ǂݍ���
function jiro_beatmap_update()
	-- ��������s��錾
	cache = data_line[bm_line_n]
	
	-- �f�t�H���g�� ������؂�o��
	flag.add = true
	
	-- �R�}���h�Ȃ� new_hit�̓R�}���h��
		-- cache�� / �܂��� ��Ȃ� �s�ύX
		if cache == "/" or length == 0 then bm_line_n = bm_line_n + 1 end
		-- cache�� , �Ȃ� new_hit �� REST��
			-- �ꔏ�x��
		if cache == "," then new_hit = "REST" flag.add = false bm_line_n = bm_line_n + 1 end
		-- cache�� (#GOGOSTART) �Ȃ� GOGOSTART��new_hit�ɒǉ�
			-- �\���摜��kiai�ɂ���
		if cache == "#GOGOSTART" then new_hit = "GOSTART" kiai = 1 flag.add = false bm_line_n = bm_line_n + 1 end
		-- cache�� (#GOGOEND) �Ȃ� GOGOEND��new_hit�ɒǉ�
			-- �\���摜��normal�ɂ���
		if cache == "#GOGOEND" then new_hit = "GOEND" kiai = 0 flag.add = false bm_line_n = bm_line_n + 1 end
		-- cache�� (END) �Ȃ� END��new_hit�ɒǉ�
			--����ɂȂ��Ă��� game_update���̏����� ���ʂ��I������(status="result")
			-- flag.end �ł��������� �����Z�k�� new_hit ���g���܂킵�B
		if cache == "#EN" or cache == "#END" then new_hit = "END" flag.add = false bm_line_n = bm_line_n + 1 end
		
	-- �����Ȃ� new_hit�͐�����؂�o��
	if flag.add == true then
		--�ǉ����镶���� num_num�Ԗ�
		num_num = cnt[4]
		--cache���� num_num�Ԗڂ�؂蔲��
		cache2 = string.sub(cache, num_num, num_num)
		--�s���L���ł��邩�Ȃ���
		if cache2 ~= "," then
			new_hit = cache2
		else
			bm_line_n = bm_line_n + 1
			-- cnt[4] = 0
		end
	end
	
	
end