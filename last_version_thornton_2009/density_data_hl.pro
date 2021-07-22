PRO density_data_hl

;extract the HL transition time from the database and get the density from the interferometer at this time

restore, 'disruption_efit_080710_area.sav' 

q=where(hl_trans gt 0.0)

shots_selected=shots[q]
hl_time_selected=hl_trans[q]

;make array for the new data
hl_density=make_array(n_elements(shots_selected))

for i=0,n_elements(q)-1 do begin

	ane=getdata('ane_density', strtrim(string(fix(shots_selected[i])),2))

	if ane.erc ne -1 then begin
		hl_pt=where(abs(ane.time-hl_time_selected[i]) eq min(abs(ane.time-hl_time_selected[i])))
		hl_density[i]=ane.data[hl_pt[0]]
	endif else begin
		hl_density[i]=-10
	endelse

endfor

data={shots:shots_selected, hl_density:hl_density, hl_time:hl_time_selected}

save, data, filename='hl_density_data.sav'

END
