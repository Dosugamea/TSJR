function game_draw()
	-- ���ʕ\��
	love.graphics.setScreen('top')
	
	--�w�i
	love.graphics.draw(background.playfield, 0,-20)
	--�X���C�_�[
	love.graphics.draw(background.slider, background.slider2X,background.slider2Y)
	love.graphics.draw(background.slider, background.sliderX,background.sliderY)
	--���ʃo�[
	love.graphics.draw(mainbar.normal, 0,81)
	
	--�Ȗ����o�[
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle( "fill", 0, 130, 400, 30 )	

	
	--����锒��
	love.graphics.setColor(255, 255, 255)
	love.graphics.line(120,50, 300)
	
	--����ʒu�摜
	love.graphics.draw(hit_timing_img, 45,76)

	--���ʔ��o�[
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle( "fill", 0, 128, 400, 12 )

	-- �s�b�s�h���̕\��
	if pippidon.anim == 0 then
		love.graphics.draw(pippidon.idle0, -5,7)
	end
	if pippidon.anim == 1 then
		love.graphics.draw(pippidon.idle1, -5,7)
	end
	if pippidon.anim == 2 then
		love.graphics.draw(pippidon.idle2, -5,7)
	end
	if pippidon.anim == 3 then
		love.graphics.draw(pippidon.idle3, -5,7)
	end
	
	if status == "game" then
		-- love.graphics.draw(don_img, hit_table_x[repeat_n],91)
	end
	
	--���ʃo�[������
	love.graphics.draw(mainbar.taiko, 0,81)

	-- �h���̔���̕\��
	if hit.don == 1 then
		love.graphics.draw(hit.donimg, 9,96)
	end
	-- �J�̔���̕\��
	if hit.ka == 1 then
		love.graphics.draw(hit.kaimg, 9,96)
	end
	
	love.graphics.draw(scorebar,100,-50)
	love.graphics.draw(scorebar_c,102,-44)
	
	--�X�R�A�̕\��
	love.graphics.draw(score_0, 296,65)
	love.graphics.draw(score_0, 308,65)
	love.graphics.draw(score_0, 320,65)
	love.graphics.draw(score_0, 332,65)
	love.graphics.draw(score_0, 344,65)
	love.graphics.draw(score_0, 356,65)
	love.graphics.draw(score_0, 368,65)
	love.graphics.draw(score_0, 380,65)
	
	love.graphics.setColor(0, 0, 0)
	-- FPS�̕\��
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 5, 220)
	-- debug
	love.graphics.print("key:"..tostring(pressed), 5, 205)
	love.graphics.print("Difficulty: "..tostring(course), 100, 205)
	love.graphics.print("time:"..tostring(timer), 250, 220)
	love.graphics.print("wait_time: "..tostring(wait_time), 250, 200)
	love.graphics.print("wait_notes: "..tostring(note_length), 250, 180)
	love.graphics.print("Line: "..tostring(bm_line_n), 100, 160)
	ht_max = table.maxn(hit_table)
	love.graphics.print("hit_table: "..tostring(hit_table[ht_max]), 100, 180)
	love.graphics.print("new_hit: "..tostring(new_hit), 250, 160)
	love.graphics.print("Level:"..tostring(level), 100, 220)

	-- �̖��\��
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(song_sub_name, subnameX, subnameY)
	love.graphics.print(song_name, 3, 141)
	-- ����ʂ̕\��
	love.graphics.setScreen('bottom')
	love.graphics.draw(bottom.taiko, 0, 0)
	love.graphics.draw(bottom.taiko, 0, bottom.taiko_Y)

	-- �h�����̍Đ�
	if noSound == false and status == "game" then
		if hit.don == 1 then
			donSound[0]:play()
			hit.don = 0
		end
	else
		hit.don = 0
	end
	
	-- �J���̍Đ�
	if noSound == false and status == "game" then
		if hit.ka == 1 then
			kaSound[0]:play()
			hit.ka = 0
		end
	else
		hit.ka = 0
	end
end