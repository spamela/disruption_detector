PRO using

;restore, 'disruption_efit_11b.sav'
restore, 'disruption_efit_0709_full.sav'

hmodeshot=make_array(n_elements(shots))
diff=ttq-hl_trans

for i=0, n_elements(shots)-1 do begin
	if(use_hl[i] eq 1 and hmode_ever[i] eq 1 and diff[i] le 0.03) then begin
		hmodeshot[i]=1
	endif
	if(use_hl[i] eq 1 and hmode_ever[i] eq 0) then begin
		hmodeshot[i]=0
	endif
	if(use_hl[i] eq 1 and hmode_ever[i] eq 1 and diff[i] gt 0.03) then begin
		hmodeshot[i]=0
	endif
endfor

;save, filename='disruption_efit_11c.sav'
;save, filename='disruption_efit_M7_11c.sav'
save, filename='disruption_efit_230610.sav'

END
