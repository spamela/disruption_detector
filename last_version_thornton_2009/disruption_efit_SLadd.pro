PRO disruption_efit_SLadd

restore, 'disruption_efit_0709_12d.sav'

continue=0

if(continue eq 0) then begin
	yag_good=make_array(n_elements(shots))
	fig_good=make_array(n_elements(shots))
	ip_25=make_array(n_elements(shots))
	wthermal_25=make_array(n_elements(shots))
	btotal_25=make_array(n_elements(shots))
	btotal_5=make_array(n_elements(shots))
endif

if(continue eq 1) then index=i
if(continue eq 0) then index=0
	
for i=index, n_elements(shots)-1 do begin

	;check to see if there is YAG and FIG data
	figdata=getdata('aga_fig', strtrim(string(fix(shots[i])),2))
	if(figdata.erc ne -1) then begin
		fig_good[i]=1
	endif else begin
		fig_good[i]=0
	endelse
	
	;yag check
	yagdata=getdata('atm_te_core', strtrim(string(fix(shots[i])),2), /noecho)
	if(yagdata.erc ne -1) then begin
		yag_good[i]=1
	endif else begin
		yag_good[i]=0
	endelse
	
	;ip 25ms before disruption
	ip=getdata('amc_plasma current', strtrim(string(fix(shots[i])),2), /noecho)
	if(ip.erc ne -1) then begin
		q=where(ip.time ge (ttq[i]-0.025))
		if(q[0] eq -1) then begin
			ip_25[i]=-10
		endif else begin
			ip_25[i]=ip.data[q[0]]
		endelse
	endif
	
	;w 25ms before disruption
	w25=getdata('efm_plasma_energy', strtrim(string(fix(shots[i])),2), /noecho)
	if(w25.erc ne -1) then begin
		q=where(w25.time ge (ttq[i]-0.025))
		if(q[0] eq -1) then begin
			wthermal_25[i]=-10
		endif else begin
			wthermal_25[i]=w25.data[q[0]]
		endelse
	endif
		
	;b total at disruption and 25ms before
	btot=getdata('efm_bphi_rmag', strtrim(string(fix(shots[i])),2), /noecho)
	if(btot.erc ne -1) then begin
		q=where(btot.time ge (ttq[i]-0.025))
		if(q[0] eq -1) then begin
			Btotal_25[i]=-10
		endif else begin
			Btotal_25[i]=btot.data[q[0]]
		endelse
	endif
	
	btot=getdata('efm_bphi_rmag', strtrim(string(fix(shots[i])),2), /noecho)
	if(btot.erc ne -1) then begin
		q=where(btot.time ge (ttq[i]-0.005))
		if(q[0] eq -1) then begin
			Btotal_5[i]=-10
		endif else begin
			Btotal_5[i]=btot.data[q[0]]
		endelse
	endif

endfor

save, filename='disruption_efit_0709_SLadd.sav'

END

