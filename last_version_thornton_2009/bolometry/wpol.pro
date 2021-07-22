PRO wpol

;read in the stored magnetic energy from efit

restore,'disruption_db_bolo_030710_v3.sav'

wpol_5=make_array(n_elements(shots))
wthermal_5=make_array(n_elements(shots))

q=where(use_hl eq 1)

for i=0, n_elements(q)-1 do begin

	wpol=getdata('efm_wpol', strtrim(string(fix(shots[q[i]])),2))
	wtherm=getdata('efm_plasma_energy', strtrim(string(fix(shots[q[i]])),2))

	time_=where(wpol.time ge ttq[q[i]]-0.005)

	if(time_[0] ne -1) then begin
		wpol_5[q[i]]=wpol.data[time_[0]]
		wthermal_5[q[i]]=wtherm.data[time_[0]]
	endif else begin
		wpol_5[q[i]]=-10
		wthermal_5[q[i]]=-10
	endelse

endfor

save, filename='disruption_bolo_030710_wpol_v3.sav'

END
