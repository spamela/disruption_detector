PRO disruption_efit_12a

;MAKE SURE THAT CORRECTING_TQ.pro has been run!!!!

;reads in disruption_efit_12f.sav which comes from correcting_tq.pro 
;outputs to disruption_efit_12g.sav

;restore, 'disruption_efit_12f.sav'
;restore, 'disruption_efit_tqfix.sav'
restore, 'disruption_efit_0709_12.sav'

time_flattop=make_array(n_elements(shots))
temp_flattop=make_array(n_elements(shots))
area_flattop=make_array(n_elements(shots))
radius_flattop=make_array(n_elements(shots))
resistance_flattop=make_array(n_elements(shots))
lp_calc_flattop=make_array(n_elements(shots))
radius_5=make_array(n_elements(shots))
radius_25=make_array(n_elements(shots))
qa_5=make_array(n_elements(shots))
qa_25=make_array(n_elements(shots))
qa_flattop=make_array(n_elements(shots))
density_5=make_array(n_elements(shots))
density_25=make_array(n_elements(shots))
minorradius_flattop=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin
	
	time_flattop[i]=findflattop(strtrim(string(fix(shots[i])),2))
	
	te=getdata('atm_te_core', strtrim(string(fix(shots[i])),2), /noecho)
	if(te.erc eq -1) then begin
		temp_flattop[i]=-10
	endif else begin
		point=where(te.time ge time_flattop[i])
		if(point[0] eq -1) then begin
			temp_flattop[i]=-2
		endif else begin
			temp_flattop[i]=te.data[point[0]]
		endelse
	endelse
	
	;added athorn 06/07/09
	minor=getdata('efm_minor_radius', strtrim(string(fix(shots[i])),2), /noecho)
	if(minor.erc eq -1) then begin
		minorradius_flattop[i]=-10
	endif else begin
		point=where(minor.time ge time_flattop[i])
		if(point[0] eq -1) then begin
			minorradius_flattop[i]=-2
		endif else begin
			minorradius_flattop[i]=minor.data[point[0]]
		endelse
	endelse
	;end athorn mods 06/07/09
	
	area=getdata('efm_plasma_area', strtrim(string(fix(shots[i])),2), /noecho)
	if(area.erc eq -1) then begin
		area_flattop[i]=-10
	endif else begin
		point=where(area.time ge time_flattop[i])
		if(point[0] eq -1) then begin
			area_flattop[i]=-2
		endif else begin
			area_flattop[i]=area.data[point[0]]
		endelse
	endelse
	
	radius=getdata('efm_magnetic_axis_r', strtrim(string(fix(shots[i])),2), /noecho)
	if(radius.erc eq -1) then begin
		radius_flattop[i]=-10
		radius_5[i]=-10
		radius_25[i]=-10
	endif else begin
		point=where(radius.time ge time_flattop[i])
		point2=where(radius.time ge (ttq[i]-0.005)[0])
		point3=where(radius.time ge (ttq[i]-0.025)[0])
		if(point[0] eq -1) then begin
			radius_flattop[i]=-2
		endif else begin
			radius_flattop[i]=radius.data[point[0]]
		endelse
		
		if(point2[0] eq -1) then begin
			radius_5[i]=-2
		endif else begin
			radius_5[i]=radius.data[point2[0]]
		endelse
		
		if(point3[0] eq -1) then begin
			radius_25[i]=-2
		endif else begin
			radius_25[i]=radius.data[point3[0]]
		endelse
	endelse
	
	;calculate the resistance - use the formula from Hutchinson for the conductivity, assume that the resistance anomaly is one (need a good reason for this) and assume that the Coulomb log is 15.
	
	if(radius_flattop[i] gt 0 and area_flattop[i] gt 0 and temp_flattop[i] gt 0) then begin
		conductivity=1.9e4*((temp_flattop[i])^(1.5))*(1/15.0)
		resistivity=1/conductivity
		resistance_flattop[i]=(resistivity*2.0*!pi*(radius_flattop[i]))/(area_flattop[i])
		Lp_calc_flattop[i]=(4.0*!pi)*(1.0e-7)*(radius_flattop[i])*((alog(8.0/(0.77*(sqrt(elongation_25[i])))))-(7.0/4.0))
	endif
	
	;get the value of q at the plasma surface at t=tq-5ms, t=tq-25ms and t=flattop
	qa=getdata('efm_q_100', strtrim(string(fix(shots[i])),2), /noecho)
	if(qa.erc eq -1) then begin
		qa_flattop[i]=-10
		qa_5[i]=-10
		qa_25[i]=-10
	endif else begin
		point=where(qa.time ge time_flattop[i])
		point2=where(qa.time ge (ttq[i]-0.005)[0])
		point3=where(qa.time ge (ttq[i]-0.025)[0])
		if(point[0] eq -1) then begin
			qa_flattop[i]=-2
		endif else begin
			qa_flattop[i]=qa.data[point[0]]
		endelse
		
		if(point2[0] eq -1) then begin
			qa_5[i]=-2
		endif else begin
			qa_5[i]=qa.data[point2[0]]
		endelse
		
		if(point3[0] eq -1) then begin
			qa_25[i]=-2
		endif else begin
			qa_25[i]=qa.data[point3[0]]
		endelse
	endelse
	
	densitydata=getdata('ane_density', strtrim(string(fix(shots[i])),2), /noecho)
	;stop
	if(densitydata.erc eq -1) then begin
		density_5[i]=-1
		density_25[i]=-1
	endif else begin
		finddensity5=where(densitydata.time ge (ttq[i]-0.005)[0])
		finddensity25=where(densitydata.time ge (ttq[i]-0.025)[0])
		;stop
		
		if(finddensity5[0] ne -1) then begin
			;print, '5ms good'
			;stop
			density_5[i]=densitydata.data[finddensity5[0]]
			;stop
		endif else begin
			;print, '5ms bad'
			density_5[i]=-1
		endelse
	
		if(finddensity25[0] ne -1) then begin
			density_25[i]=densitydata.data[finddensity25[0]]
		endif else begin
			density_25[i]=-1
		endelse
	endelse
	
	;print, 'STOP .c'
	
	;stop
endfor
	
;save, filename='disruption_efit_12g.sav'
;save, filename='disruption_efit_ITPA_020709.sav'
save, filename='disruption_efit_0709_12a.sav'


END
