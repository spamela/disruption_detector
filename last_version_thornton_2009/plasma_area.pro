PRO plasma_area

restore, 'disruption_efit_080710.sav'

q=where(use_hl eq 1)
area_5=make_array(n_elements(shots))

for i=0, n_elements(q)-1 do begin
	
	a=getdata('efm_plasma_area', strtrim(string(fix(shots[q[i]])),2))

	if(a.erc ne -1) then begin
		time=where(a.time ge ttq[q[i]]-0.005)
		if(time[0] ne -1) then begin
			area_5[q[i]]=a.data[time[0]]
		endif else begin
			area_5[q[i]]=-10
		endelse
	endif else begin
		area_5[q[i]]=-20
	endelse
endfor

save, filename='disruption_efit_080710_area.sav'

END
			
