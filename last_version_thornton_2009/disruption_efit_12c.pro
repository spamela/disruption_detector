PRO disruption_efit_12c

	;restore, 'disruption_efit_12b.sav'
	restore, 'disruption_efit_0709_tqfix.sav'
	
	sxr_peak_tq=make_array(n_elements(shots))
	
	q=where(good_tq eq 1)
	
	for i=0, n_elements(q)-1 do begin
		sxr_peak_tq[q[i]]=sxr_peak(strtrim(string(fix(shots[q[i]])),2))
	endfor
	
	;save, filename='disruption_efit_12c.sav'
	save, filename='disruption_efit_0709_12c.sav'
	
END