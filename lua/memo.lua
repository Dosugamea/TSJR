--����

-- love.update(dt) �́@���t���[���Ăяo����܂�, 
-- ��{�I�ɂ̓Q�[�����W�b�N�Ɏg�p����܂��B
-- ���� dt ���� �� �t���[���Ԃ̕��ώ��ԁA�f���^�^�C���ł�
--  (�f���^�^�C��=�O�̃t���[���ƍ��̃t���[���̎��ԓI�ȍ���)
-- �Q�[���̃t���[�����[�g�Ɉˑ����Ȃ��悤�ɂ��邽�߂ɂ� ������g���Ă�������
�@ 
-- love.draw() ���t���[�����ɌĂяo����܂��B
-- ��ʂ̏��������͑S�Ă����ɋL�q���Ă��������B

-- love.keypressed �� ���炩�̃{�^���������ꂽ�Ƃ��ɌĂяo����܂�
-- key �Ƃ��������� �����ꂽ�{�^���ł��B
-- �{�^������ԍŌ�܂ŉ�����Ă����Ԃ��擾�������ꍇ�A�S�ẴC���v�b�g�R�[�h�������ɏ����Ȃ��ł��������B
-- love.update(dt) �ƂƂ��� love.keyboard.isDown() ��p���Ă�������

-- love.quit �� LovePotion �̏I�����ɌĂяo����܂�
-- �N���[���A�b�v�R�[�h�Ȃǂ͂����ɏ�������ł��������B


-- local = ���s����function���݂̂Œ�`����
-- (function�O�Ŏg������ۂ̕ϐ��͈ێ����ꂽ�܂�)

-- font = love.graphics.newFont()
-- �V�����t�H���g���`, �����Ȃ��Ńf�t�H���g�t�H���g���g�p�B


-- love.graphics.setScreen('bottom')
-- ���삷���ʂ��w�肷�� (���̏ꍇ ����)
-- �ēx���̖��߂��Ăяo����ĕύX�����܂ŗL��

-- love.graphics.newImage('')
-- ����p�X����t�@�C���̓ǂݍ���

--love.graphics.getWidth()/getHeight() ����� Image:getWidth()/getHeight()
-- ��ʃT�C�Y/�摜�T�C�Y�̎擾



-- �Â��R�[�h
-- �ǂ��Ɏg�����Ƃ����񂾂������C���Ȃ�
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
	
	-- Level �� �s������� #START�ʒu��T��
	-- ���ʃf�[�^�̊J�n�s�����w��
	while search_end == false do
		--�����s�ύX
		cnt[5] = cnt[5] + 1
		--#START������
		start_r = string.find(data_line[cnt[5]], "#START")
		--����������A ���ʖ{�̂̍s�� #START�̍s + 1�s�ڂł���B
		if start_r ~= nil then
			bm_line_n = cnt[5] + 1
			--start_r �͌��������B
			search_end = true
		end
	end

	
--	 Nightly 0130 ���
	-- ���[�h���Ƀ��[�v�� data_line���̕��ʂ�S����������@
	-- �e�[�u���̃������I�[�o�[�Ŗv��

	-- #END�����������܂Ń��[�v���J��Ԃ�
	while var_end == false do
			-- �����𕪉����Ēǉ����邩�̃t���O
		flag.add = true
		-- new_hit_table�̉��Ԗڂ̗v�f��
		bm_line_n = bm_line_n + 1
		cnt[5] = cnt[5] + 1
		-- �������̕����̒���

		-- data_line[bm_line_n]�� (#GOGOSTART) �Ȃ� GOGOSTART��new_hit�ɒǉ�
		if data_line[bm_line_n] == "#GOGOSTART" then new_hit[cnt[5]] = "GOGOSTART" flag.add = false end	
		-- data_line[bm_line_n]�� (#GOGOEND) �Ȃ� GOGOEND��new_hit�ɒǉ�
		if data_line[bm_line_n] == "#GOGOEND" then new_hit[cnt[5]] = "GOGOEND" flag.add = false end
		-- data_line[bm_line_n]�� (END) �Ȃ� END��new_hit�ɒǉ� ���� ���^�I��
		if data_line[bm_line_n] == "#EN" or data_line[bm_line_n] == "#END" then new_hit[cnt[5]] = "END" flag.add = false var_end = true end
		
		-- / ������������A�܂��͍s����Ȃ�B �ǉ������Ɏ��̍s��
		if data_line[bm_line_n] == "/" or length == 0 then flag.add = false end
		-- , ������������B	 1���x�݂�ǉ����Ď��̍s��
		if data_line[bm_line_n] == "," then new_hit[cnt[5]] = "REST" flag.add = false end

		if flag.add == true then add_word() end

	end
	
function add_word()
		-- ���܂ł̃X�e�b�v�Œe����Ȃ����� �����̍s�ł����
			-- �s�ǉ����[�v�J�n
			-- �s�̕�������1�ɂȂ�܂ŌJ��Ԃ�
		local z = 0
		
		repeat
			-- ���݂̍s�̕������o��
			z = z + 1
			word = string.sub(data_line[bm_line_n], z, z)

			-- ���� cache �� , �Ȃ� �I�� 
			if word == "," then
				add_end = true
				new_hit[cnt[5]] = ","
				cnt[5] = cnt[5] + 1
			else
				-- ���ʂ̐����Ȃ�
				-- �e�[�u���� ���݂̍s��1�����ڂ�ǉ�
				new_hit[cnt[5]] = word
				cnt[5] = cnt[5] + 1
			end

		until add_end == true
		cnt[5] = cnt[5] - 1
end


--�ŏ��̏o���ʒu
-- hit_table_x = 395
--�������T�C�Y�Ȃ� hit_table_x
--�傫���T�C�Y�Ȃ� hit_table_x + 5

-- ����ʒu
-- decision_p = 60
-- �������T�C�Y�Ȃ� decision_p
-- �傫���T�C�Y�Ȃ� decision_p - 5

-- �ړ����x = �o���ʒu - ����ʒu / �����鎞��

--���W��Ŕ��肵���炱��Ȋ���
if hit_table[1] < decision_p + 5 or hit_table[1] > decision_p - 5
	--��
else if hit_table[1] < decision_p + 10 or hit_table[1] > decision_p - 10
	--��
	else �@
	--�s��
	end
end

--�m�[�g�̕��������N����
	-- 2/1

-- cnt[9] �� �V������ʂɕ\�������镈�ʂ�ID
--BPM�͎��O�Ɏ��o����BPM�ŊԈႢ�Ȃ��B
BPM = bpm
--1���̕������� �\�߃e�[�u���Ɏ��o����������(�Ƃ肠����cnt[8]�Ԗڂ��w��)
beat_1 = wait_table[cnt[8]]
-- �ꔏ�ɂ����鎞��(1�s�̏����ɂ����鎞��)
beat_time = 60 / BPM
-- ����1�ɂ����鎞��(1�����̏����ɂ����鎞��)
wait_time = beat_time / wait_table[cnt[8]]

--�R�}���h #BPMCHANGE(���l) �� ���ŗ����� BPMCHANGE
function bgm_change()
	beat_time = 60 / bpm
end

function beatmap_var
	-- ��Ԃ͂��߂̋����Ԃ� ���x���ʂ��J�n�����^�C�~���O
	old_timer = 0
	-- ���ۂɉ�ʂɕ\�����镈�ʂ̐�(���)
	hit_table = {}
	-- ���ۂɉ�ʂɕ\�����镈�ʂ̍��W(X��)
	hit_table_x = {}
end

function beatmap_jiro_update
	--new_hit����Ȃ玟�̍s�ɐi�݁A�ҋ@���Ԃ��Đݒ肷��
	if new_hit == "" then
		cnt[8] = cnt[8] + 1
		next_line() --���ʂ����̍s��
		wait_time = beat_time / wait_table[cnt[8]] --�ҋ@���Ԑݒ�
	end
	-- �ȑO�̃^�C�}�[�̒l����A��L�Őݒ肵���ҋ@���Ԍo�߂����� hit_table��new_hit��ǉ�����B
	if timer > oldtimer + wait_time then
		hit_table[cnt[9]] = new_hit --��ʏ�ɕ\�����镈�ʂ�new_hit����
		hit_table_x[cnt[9]] = 0 --��ʏ�ł̊J�n�ʒu
		old_timer = timer -- �ȑO�̃^�C�}�[�̒l�͍��̃^�C�}�[�̒l
	end
	
	-- hit_table_x��S�ē�����
	local n = 0
	repeat
		n = n + 1
		hit_table_x[n] = hit_table_x - move_x
	until n == table.maxn(hit_table)
	
	-- hit_table��hit_table_x���� ��ʂ���ʂ�߂����S�~���폜����
	-- �ǂ����܂���
end

���h��/�J�b = 91
��h��/�J�b = 86


		-- new_hit�� �R�}���h����Ȃ���� ���X�g�ɒǉ�
		if new_hit ~= "NEXT" and new_hit ~= "REST" and new_hit ~= "GOSTART" and new_hit ~= "GOEND" and new_hit ~= "GOEND" and new_hit ~= 0 then
			table.insert(hit_table, new_hit)
			-- ��ʏ�ɕ\�����镈�ʂ�new_hit����
			if new_hit ~= 3 and new_hit ~= 4 and new_hit ~= 6 then
				table.insert(hit_table_x, 395)
				-- ��ʏ�ł̊J�n�ʒu���� (�������z�̏ꍇ)
			else
				table.insert(hit_table_x, 400)
				-- ��ʏ�ł̊J�n�ʒu���� (�ł����z�̏ꍇ)
			end
		end
		
		--�J��Ԃ��񐔂� hit_table_x �̌�
		for_x_table = table.maxn(hit_table_x)
		
		-- n�Ԗڂ� ���ڂ� ���ɓ�����
		for i=1, for_x_table do
			hit_table_x[i] = hit_table_x[i] - 3
		end
		