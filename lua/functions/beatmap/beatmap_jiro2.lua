-- ToDo.
-- ����ɐ؂�o����悤�ɂ��남������������!!!!
-- #GOGOSTART �� #GOGOEND �� #END �� #BPMCHANGE �� ���򕈖� �� �����͂ǂ�?

function jiro_beatmap_var()
	--�e�t���O�̐錾 �� �f�o�b�O�p
	var_end = true
	flag.add = true
	add_end = true
	bm_line_n = 0
	extract = 0
	extract_num = 0
	ex_num_add = 0
	
	course_l = course_line[4] --�@�R�[�X�ꗗ����w�肵���ԍ��̍s�ԍ����擾 ����͋��� Easy
	level_l = level_line[4] --���x���ꗗ����w�肵���ԍ� ����͋���3
	bm_line_n = start_line[4] + 1 -- �X�^�[�g�n�_�ꗗ����course_line �Ɉ�ԋ߂��ԍ� ����͋����I��Easy�̍s����J�n
	
	level = string.sub(data_line[level_l], 7) -- ���x���̐����؂�o��
	course = string.sub(data_line[course_l], 8) -- �R�[�X�̖��̂̐؂�o��

	
	-- �e�s�ɏ����Ă��镈�ʂ����s����e�[�u���ɕϊ�����
	
	-- #END�����������܂Ń��[�v���J��Ԃ�
	while var_end == false do
			-- �����𕪉����Ēǉ����邩�̃t���O
		flag.add = true
		-- new_hit_table�̉��Ԗڂ̗v�f��
		cnt[5] = cnt[5] + 1

		local length = #data_line[bm_line_n]
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
		
		bm_line_n = bm_line_n + 1

		
		-- ���܂ł̃X�e�b�v�Œe����Ȃ����� �����̍s�ł����
		if flag.add == true then
			-- �s�ǉ����[�v�J�n
			-- �s�̕�������1�ɂȂ�܂ŌJ��Ԃ�
			extract_num = data_line[bm_line_n]
			local length = #extract_num - 1
			
				-- ���݂̍s�́@���݂̍s��2�����ڂ���Ō�̕����܂�
				extract_num = string.sub(extract_num, 2)
				-- �ǉ����镶���� ���݂̍s�� 1������
				ex_num_add = string.sub(extract_num, 1, 1)
				new_hit[cnt[5]] = ex_num_add
				cnt[5] = cnt[5] + 1
			add_end = true
			bm_line_n = bm_line_n + 1
			flag.add = false
		end
	end
end