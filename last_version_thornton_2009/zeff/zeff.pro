PRO zeff

;program to read zeff and plot as a function of shot or cq time

;restore last save file
restore, '../disruption_efit_300610_2.sav'

zeff=make_array(n_elements(shots))
zeff_tq=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin

	print, strtrim(string(fix(shots[i])),2)

	a=getdata('aze_zeff', strtrim(string(fix(shots[i])),2),/noecho)
	if a.erc eq -1 then a=getdata('aze_central_zeff_nd-yag',strtrim(string(fix(shots[i])),2), /noecho)

	if a.erc ne -1 then begin

		q=where(abs(a.time-ttq[i]) eq min(abs(a.time-ttq[i])))
		if q ne -1 then begin
			zeff_tq[i]=a.data[q]
		endif else begin
			zeff_tq[i]=-1
		endelse

		q=n_elements(a.time)/2 ;put this in the middle of the shot
		if q ne -1 then begin
			zeff[i]=a.data[q]
		endif else begin
			zeff[i]=-2
		endelse

	endif else begin

		zeff_tq[i]=-10
		zeff[i]=-10

	endelse

endfor

save, filename='disruption_efit_141210_zeff.sav'

END
