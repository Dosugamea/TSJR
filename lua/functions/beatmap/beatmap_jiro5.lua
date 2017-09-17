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
	
	line_max = table.maxn(data_line)
	
	--���������e�[�u���ɋL�^
	repeat
		-- ���݂̍s�̃f�[�^��ǂݍ���
		local note_cache = data_line[bm_line_n]
		local note_length = #note_cache
		local comment_r = string.find(note_cache, "/")
		local comment2_r = string.sub(note_cache, 1, 1)

		-- �Ƃ肠���������Ƃ��Đ�����(�����ɂ���ĉ����ł��邩�Ȃ�����ς���)
		notes = true
		-- �f�[�^����v�܂��͊܂܂��� ����͉����ł͂Ȃ��B �s��ς���
		if comment2_r == "/" then notes = false end --�R�����g�s�̃f�[�^�̓f�[�^�Ȃ��B
		if note_cache == "," then wait_notes[notes_cnt] = "max" notes = false end --���̍s�� �S����
		if note_cache == "#GOGOSTART" then wait_notes[notes_cnt] = "GOSTART" notes = false end --�R�}���h gostart
		if note_cache == "#GOGOEND" then wait_notes[notes_cnt] = "GOEND" notes = false end --�R�}���h goend
		if note_cache == "#EN" or note_cache == "#END" then wait_notes[notes_cnt] = "END" notes_end = true end --�R�}���h end
		if notes == true then
			--�R�����g���s�Ɋ܂܂�Ă���ꍇ
			if comment_r ~= nil then
				--1�����ڂ���J�n
				line_n = 1
				repeat
					--cm_num�� line_n������
					cm_num = string.sub(note_cache, line_n, line_n)
					--���� cm_num�� "," �ł���� comments_end ��true�ɂ��ă��[�v���I������ ���݂̍s��wait_note�� line_n�����܂�(��)
					if cm_num == "," then comments_end = true wait_notes[notes_cnt] = line_n - 1 end
					line_n = line_n + 1
				until comments_end == true
			else
				if note_length == 0 then
					wait_notes[notes_cnt] = "F"
				else
					wait_notes[notes_cnt] = note_length - 1
				end
			end
		end
		
		notes_cnt = notes_cnt + 1
		next_l()
	until notes_end == true
	
	bm_line_n = start_line[4] + 1  -- �X�^�[�g�n�_�ꗗ����course_line �Ɉ�ԋ߂��ԍ� ����͋����I��Easy�̍s����J�n

end

-- game_draw�̎��� ���ʂ̎�ނ�ǂݍ���
function jiro_beatmap_update()
	old_cnt = hit_cnt - 1
	--���݂̍s�̐����� nil�Ȃ�s�����艟���ŕς���`�[�g�B
	yes_nil = false
	-- nil�ł����nil�ł͂Ȃ��s�܂�+1���郋�[�v�˓�
	if wait_notes[debug_cnt] == nil then yes_nil = true end
	-- nil�ł���� �s�ς���nil���ǂ����m�F
	while yes_nil == true do
		debug_cnt = debug_cnt + 1
		if wait_notes[debug_cnt] ~= nil then yes_nil = false end
	end

	
	-- ��������s�̕�����錾
	cache = data_line[bm_line_n]
	--1���̕������� �\�߃e�[�u���Ɏ��o����������(�Ƃ肠����cnt[8]�Ԗڂ��w��)
	-- beat_1 = wait_notes[now_l]
	-- �ꔏ�ɂ����鎞��(1�s�̏����ɂ����鎞��)
	beat_time = 60 / bpm
	-- ����1�ɂ����鎞��(1�����̏����ɂ����鎞��)
	-- wait_time = beat_time / beat_1
	wait_time = 0.3
	
	-- �f�t�H���g�� ������؂�o��
	if hit_cnt > old_cnt then
	flag.add = true
	end
	
	local comment_r = string.find(cache, "/")
	local length = #cache
	-- �R�}���h�Ȃ� new_hit�̓R�}���h��
		-- cache�� / �܂��� ��Ȃ� �s�ύX
		if comment_r ~= nil or length == 0 then flag.add = false hit_cnt = 1 next_l() end
		-- cache�� , �Ȃ� new_hit �� REST��
			-- �ꔏ�x��
		if cache == "," then new_hit = "REST" flag.add = false next_l() hit_cnt = 1 end
		-- cache�� (#GOGOSTART) �Ȃ� GOGOSTART��new_hit��
			-- �\���摜��kiai�ɂ���
		if cache == "#GOGOSTART" then new_hit = "GOSTART" kiai = 1 flag.add = false next_l() hit_cnt = 1 end
		-- cache�� (#GOGOEND) �Ȃ� GOGOEND��new_hit��
			-- �\���摜��normal�ɂ���
		if cache == "#GOGOEND" then new_hit = "GOEND" kiai = 0 flag.add = false next_l() hit_cnt = 1 end
		-- cache�� (END) �Ȃ� END��new_hit�ɒǉ�
			--����ɂȂ��Ă��� game_update���̏����� ���ʂ��I������(status="result")
			-- flag.end �ł��������� �����Z�k�� new_hit ���g���܂킵�B
		if cache == "#EN" or cache == "#END" then new_hit = "END" flag.add = false next_l() hit_cnt = 1 end
		
	-- �����Ȃ� new_hit�͐�����؂�o��
	if flag.add == true then
		--cache���� num_num�Ԗڂ�؂蔲��
		local cache2 = string.sub(cache, hit_cnt, hit_cnt)
		--�s���L���ł��邩�Ȃ���
		if cache2 ~= "," then
			new_hit = cache2
		else
			next_l()
			hit_cnt = 1
			debug_cnt = debug_cnt + 1
		end
	end
	
	-- ���O�Ɍv�Z���� 1�����ɂ����鏈�����Ԍo�߂����玟�̕����ɕύX
	if timer > old_timer + wait_time then
		hit_cnt = hit_cnt + 1 --�؂�o��������ύX
		-- table.insert(hit_table, new_hit) --��ʏ�ɕ\�����镈�ʂ�new_hit����
		-- hit_table_x[hits_cnt] = 0 --��ʏ�ł̊J�n�ʒu
		old_timer = timer -- �ȑO�̃^�C�}�[�̒l�͍��̃^�C�}�[�̒l
	end
end