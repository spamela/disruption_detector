PRO disruption_efit_8

;restore, 'disruption_efit_7.sav'
;restore, 'disruption_efit_M7_7.sav'
restore, 'disruption_efit_0709_7.sav'

btoroidal_5=make_array(n_elements(shots))
btoroidal_25=make_array(n_elements(shots))
minorradius_5=make_array(n_elements(shots))
minorradius_25=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin

	btoroidaldata=getdata('efm_bphi_rmag', strtrim(string(fix(shots[i])),2))
	minorradiusdata=getdata('efm_minor_radius', strtrim(string(fix(shots[i])),2), /noecho)
	
	if(btoroidaldata.erc eq -1) then begin
		btoroidal_5[i]=-10
		btoroidal_25[i]=-10
	endif else begin
		find5=where(btoroidaldata.time ge (ttq[i]-0.005))
		find25=where(btoroidaldata.time ge (ttq[i]-0.025))
		if(find5[0] eq -1) then begin
			btoroidal_5[i]=-10
		endif else begin
			btoroidal_5[i]=btoroidaldata.data[find5[0]]
			btoroidal_25[i]=btoroidaldata.data[find25[0]]
		endelse
	endelse
	
	if(btoroidaldata.erc eq -1) then begin
		minorradius_5[i]=-10
		minorradius_25[i]=-10	
	endif else begin
		find5=where(minorradiusdata.time ge (ttq[i]-0.005))
		find25=where(minorradiusdata.time ge (ttq[i]-0.025))
		if(find5[0] eq -1) then begin
			minorradius_5[i]=-10
		endif else begin
			minorradius_5[i]=minorradiusdata.data[find5[0]]
			minorradius_25[i]=minorradiusdata.data[find25[0]]
		endelse
	endelse
	
endfor

;save, filename='disruption_efit_8.sav'
;save, filename='disruption_efit_M7_8.sav'
save, filename='disruption_efit_0709_8.sav'

END
	
	
	