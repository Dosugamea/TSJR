function osu_beatmap_var()

end

function osu_timing_table()
	cnt[3] = search[1]
	while search_end == false do
		cnt[3] = cnt[3]  + 1
		if endpoint[1] == cnt[3] then
			search_end = true
		end
	end
end

function osu_hit_table()
	while search_end == false do
		search2 = search2 + 1
		searchend_r = #data_line[search2]
		if searchend_r == 0 then
			search_end = true
		end
	end
end

