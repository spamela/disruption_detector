PRO disruption_efit_5

;run after disruption_efit_4

;finds the values of betap, betan, betat, q0, q95, elongation, dr_sep, li density, at 5ms before the disruption, one confinement time before the disruption

;restore, 'disruption_efit_4.sav'
;restore, 'disruption_efit_M7_4.sav'
restore, 'disruption_efit_0709_4.sav'

betan_5=make_array(n_elements(shots))
betap_5=make_array(n_elements(shots))
betat_5=make_array(n_elements(shots))
q0_5=make_array(n_elements(shots))
q95_5=make_array(n_elements(shots))
elongation_5=make_array(n_elements(shots))
li_5=make_array(n_elements(shots))
drsep_5=make_array(n_elements(shots))
density_5=make_array(n_elements(shots))
betan_25=make_array(n_elements(shots))
betap_25=make_array(n_elements(shots))
betat_25=make_array(n_elements(shots))
q0_25=make_array(n_elements(shots))
q95_25=make_array(n_elements(shots))
elongation_25=make_array(n_elements(shots))
li_25=make_array(n_elements(shots))
drsep_25=make_array(n_elements(shots))
density_25=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin

	if(ttq[i] gt 10 or finite(ttq[i]) eq 0) then goto, endofall
	
	;get the EFIT data
	betandata=getdata('EFM_BETAN',strtrim(string(fix(shots[i])),2))
	betapdata=getdata('EFM_BETAP',strtrim(string(fix(shots[i])),2),/noecho)
	betatdata=getdata('EFM_BETAT',strtrim(string(fix(shots[i])),2),/noecho)
	q0data=getdata('EFM_Q_AXIS',strtrim(string(fix(shots[i])),2),/noecho)
	q95data=getdata('EFM_Q_95',strtrim(string(fix(shots[i])),2),/noecho)
	elongationdata=getdata('EFM_ELONGATION',strtrim(string(fix(shots[i])),2),/noecho)
	lidata=getdata('EFM_LI',strtrim(string(fix(shots[i])),2),/noecho)
	drsepdata=getdata('ESM_DR_SEP_OUT',strtrim(string(fix(shots[i])),2),/noecho)
	
	if(drsepdata.erc eq -1) then begin
		drsep_5[i]=-1
		drsep_25[i]=-1
	endif else begin
		find5=where(drsepdata.time ge (ttq[i]-0.005))
		find25=where(drsepdata.time ge (ttq[i]-0.025))
		
		if(find5[0] ne -1) then begin
			drsep_5[i]=drsepdata.data[find5[0]]
		endif else begin
			drsep_5[i]=-1
		endelse
		
		if(find25[0] ne -1) then begin
			drsep_25[i]=drsepdata.data[find25[0]]
		endif else begin
			drsep_25[i]=-1
		endelse
		
	endelse
		
	if(betandata.erc eq -1) then begin
		betan_5[i]=-1
		betap_5[i]=-1
		betat_5[i]=-1
		q0_5[i]=-1
		q95_5[i]=-1
		elongation_5[i]=-1
		li_5[i]=-1
		betan_25[i]=-1
		betap_25[i]=-1
		betat_25[i]=-1
		q0_25[i]=-1
		q95_25[i]=-1
		elongation_25[i]=-1
		li_25[i]=-1
		goto, finish
	endif
		
	;find the point where the traces are 5ms before and one confinement time (25ms) before the TQ time (ttq variable)
	
	find5=where(betandata.time ge (ttq[i]-0.005))
	
	if(find5[0] eq -1) then begin
		betan_5[i]=-1
		betap_5[i]=-1
		betat_5[i]=-1
		q0_5[i]=-1
		q95_5[i]=-1
		elongation_5[i]=-1
		li_5[i]=-1
		goto, find25data
	endif
		
	betan_5[i]=betandata.data[find5[0]]
	betap_5[i]=betapdata.data[find5[0]]
	betat_5[i]=betatdata.data[find5[0]]
	q0_5[i]=q0data.data[find5[0]]
	q95_5[i]=q95data.data[find5[0]]
	elongation_5[i]=elongationdata.data[find5[0]]
	li_5[i]=lidata.data[find5[0]]
	
find25data:
		
	find25=where(betandata.time ge (ttq[i]-0.025))
	
	if(find25[0] eq -1) then begin
		betan_25[i]=-1
		betap_25[i]=-1
		betat_25[i]=-1
		q0_25[i]=-1
		q95_25[i]=-1
		elongation_25[i]=-1
		li_25[i]=-1
		goto, finish
	endif
	
	betan_25[i]=betandata.data[find25[0]]
	betap_25[i]=betapdata.data[find25[0]]
	betat_25[i]=betatdata.data[find25[0]]
	q0_25[i]=q0data.data[find25[0]]
	q95_25[i]=q95data.data[find25[0]]
	elongation_25[i]=elongationdata.data[find25[0]]
	li_25[i]=lidata.data[find25[0]]
	
finish:
	
	;find the density information
	densitydata=getdata('ane_density', strtrim(string(fix(shots)),2), /noecho)
	
	if(densitydata.erc eq -1) then begin
		density_5[i]=-1
		density_25[i]=-1
		goto, endofall
	endif
	
	finddensity5=where(densitydata.time ge (ttq[i]-0.005))
	finddensity25=where(densitydata.time ge (ttq[i]-0.025))
	
	if(finddensity5[0] ne -1) then begin	
		density_5[i]=densitydata.data[finddensity5[0]]
	endif else begin
		density_5[i]=-1
	endelse
	
	if(finddensity25[0] ne -1) then begin
		density_25[i]=densitydata.data[finddensity25[0]]
	endif else begin
		density_25[i]=-1
	endelse
	
endofall:
	

endfor

;save, filename='disruption_efit_5.sav'
;save, filename='disruption_efit_M7_5.sav'
save, filename='disruption_efit_0709_5.sav'

END