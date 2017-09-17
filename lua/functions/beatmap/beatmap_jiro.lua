-- �������� bm_line_n = bm_line_n + 1 �����̂߂�ǂ����� �Z�k�R�}���h���쐬�B
function next_l()
	bm_line_n = bm_line_n + 1
end

--�R�}���h #BPMCHANGE(���l) �� ���ŗ����� BPMCHANGE
function bgm_change()
	beat_time = 60 / bpm
end

function jiro_beatmap_var()
	--�e�t���O�̐錾 �� �f�o�b�O�p
	old_timer = 0 -- ��Ԃ͂��߂̋����Ԃ� ���x���ʂ��J�n�����^�C�~���O	
	hit_table = {} -- ���ۂɉ�ʂɕ\�����镈�ʂ̐�(���)
	hit_table_x = {} -- ���ۂɉ�ʂɕ\�����镈�ʂ̍��W(X��)
	course_l = course_line[4] --�@�R�[�X�ꗗ����w�肵���ԍ��̍s�ԍ����擾 ����͋��� Easy
	level_l = level_line[4] --���x���ꗗ����w�肵���ԍ� ����͋���3
	bm_line_n = start_line[4] + 1  -- �X�^�[�g�n�_�ꗗ����course_line �Ɉ�ԋ߂��ԍ� ����͋����I��Easy�̍s����J�n
	wait_notes = {} -- �e�s�̉�������ۑ�����e�[�u��
	notes = true -- ���̍s�͐����ł��邩�A�̃t���O
	notes_end = false -- �������L�^ ���[�v�̏I���t���O
	comments_end = false --�R�����g�p�̌��݂̕�����
	level = string.sub(data_line[level_l], 7) -- ���x���̐����؂�o��
	course = string.sub(data_line[course_l], 8) -- �R�[�X�̖��̂̐؂�o��
	old_cnt = 0
	note_length = 0
	flag.nx_l = true
	old_timer_pippi = 0
end

-- game_draw�̎��� ���ʂ̎�ނ�ǂݍ���
function jiro_beatmap_update()
	-- �ʂ�߂������ �폜�����t���O
	flag.delete_end = false

	--nil�΍�
	
	-- �f�t�H���g�� ������؂�o��
	if hit_cnt > old_cnt then
		flag.add = true
	end
	
	if hit_cnt > old_cnt and new_hit == "GOSTART" then
		hit_cnt = 1
		next_l()
		old_cnt = hit_cnt
	end

	if hit_cnt > old_cnt and new_hit == "GOEND" then
		hit_cnt = 1
		next_l()
		old_cnt = hit_cnt
	end
	
	if hit_cnt > old_cnt and new_hit == "NEXT" then
		hit_cnt = 1
		next_l()
		old_cnt = hit_cnt
	end
	
	if hit_cnt > old_cnt and new_hit == "REST" then
		if data_line[bm_line_n + 1] == "#GOGOSTART" then hit_cnt = 0 else hit_cnt = 1 end
		next_l()
		old_cnt = hit_cnt
	end

	-- ��������s�̕�����錾
	cache = data_line[bm_line_n]
	
	
	local comment_r = string.find(cache, "/")
	local length = #cache
	-- �R�}���h�Ȃ� new_hit�̓R�}���h��
		-- cache�� / �܂��� ��Ȃ� �s�ύX
		if comment_r ~= nil or length == 0 then new_hit = "NEXT" note_length = 0 flag.add = false hit_cnt = 1 old_cnt = hit_cnt end
		-- cache�� , �Ȃ� new_hit �� REST��
			-- �ꔏ�x��
		if cache == "," then new_hit = "REST" note_length = 0 flag.add = false old_cnt = hit_cnt hit_cnt = 1 end
		-- cache�� (#GOGOSTART) �Ȃ� GOGOSTART��new_hit��
			-- �\���摜��kiai�ɂ���
		if cache == "#GOGOSTART" then new_hit = "GOSTART" note_length = 0 kiai = 1 flag.add = false old_cnt = hit_cnt hit_cnt = 1 end
		-- cache�� (#GOGOEND) �Ȃ� GOGOEND��new_hit��
			-- �\���摜��normal�ɂ���
		if cache == "#GOGOEND" then new_hit = "GOEND" note_length = 0 kiai = 0 flag.add = false old_cnt = hit_cnt hit_cnt = 1 end
		-- cache�� (END) �Ȃ� END��new_hit�ɒǉ�
			--����ɂȂ��Ă��� game_update���̏����� ���ʂ��I������(status="result")
			-- flag.end �ł��������� �����Z�k�� new_hit ���g���܂킵�B
		if cache == "#EN" or cache == "#END" then new_hit = "END" note_length = 0 flag.add = false end

	-- �����Ȃ� new_hit�͐�����؂�o��
	if flag.add == true then
		--cache���� num_num�Ԗڂ�؂蔲��
		local cache2 = string.sub(cache, hit_cnt, hit_cnt)
		--�s���L���ł��邩�Ȃ���
		if cache2 ~= "," then
			note_length = #cache - 1
			new_hit = cache2
		else
			next_l()
			hit_cnt = 1
			old_cnt = hit_cnt
		end
	end
	
	-- �ꔏ�ɂ����鎞��(1�s�̏����ɂ����鎞��)
	beat_time = 60 / bpm * 4
 	
	-- ����1�ɂ����鎞��(1�����̏����ɂ����鎞��)
	if note_length ~= 0 then
	wait_time = beat_time / note_length
	else
		if new_hit == "REST" then wait_time = beat_time else wait_time = 0.0000001 end
	end
	
	-- ���O�Ɍv�Z���� 1�����ɂ����鏈�����Ԍo�߂����玟�̕����ɕύX
	if timer > old_timer + wait_time and new_hit ~= "END" then
		hit_cnt = hit_cnt + 1 --�؂�o��������ύX
		
		if new_hit ~= "NEXT" and new_hit ~= "REST" and new_hit ~= "GOSTART" and new_hit ~= "GOEND" and new_hit ~= "GOEND" and new_hit ~= 0 then
			table.insert(hit_table, new_hit)
		end
		
		old_timer = timer -- �ȑO�̃^�C�}�[�̒l�͍��̃^�C�}�[�̒l
	end
end