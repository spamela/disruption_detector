PRO disruption_efit_280610

restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_260610.sav'

;run the thermal quench anaylsis code for the shots where use_2606010 eq 1 and not where use eq 1

q=where(use_260610 eq 1 and use eq 0 and shots ne 22228)

more, q

;stop

for i=0, n_elements(q)-1 do begin

	ttq_sxr[q[i]]=tq_funct(strtrim(string(fix(shots[q[i]])),2))

endfor

save, filename='disruption_efit_280610.sav'

;stop

END
