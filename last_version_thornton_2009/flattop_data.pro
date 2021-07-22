PRO flattop_data

restore, 'disruption_efit_0709_SLadd.sav'
;restore, 'disruption_Efit_ITPA_plusflattop.sav'

index=0
continue=0

if(continue eq 0) then begin

drsep_midflattop=make_array(n_elements(shots))
density_midflattop=make_array(n_elements(shots))
nbi_midflattop=make_array(n_elements(shots))
ip_midflattop=make_array(n_elements(shots))
flattoptime=make_array(n_elements(shots))
w_midflattop=make_array(n_elements(shots))
betan_midflattop=make_array(n_elements(shots))
betap_midflattop=make_array(n_elements(shots))
betat_midflattop=make_array(n_elements(shots))
li_midflattop=make_array(n_elements(shots))
zmagaxis_midflattop=make_array(n_elements(shots))
btoroidal_midflattop=make_array(n_elements(shots))
index=0

endif

for i=index, n_elements(shots)-1 do begin

	if(shots[i] eq 19316) then goto, nextshot

	flattime=findflattop(strtrim(string(fix(shots[i])),2))
	flattoptime[i]=flattime
	
	;stop
	
	if(flattime ne -10 and shots[i] ne 19316) then begin

	drsepdata=getdata('esm_dr_sep_out', strtrim(string(fix(shots[i])),2), /noecho)
	if(drsepdata.erc ne -1) then begin
		q=where(drsepdata.time ge flattime)
		if(q[0] eq -1) then begin
			drsep_midflattop[i]=-10
		endif else begin
			drsep_midflattop[i]=drsepdata.data[q[0]]
		endelse
	endif
	
	dense=getdata('ane_density', strtrim(string(fix(shots[i])),2), /noecho)
	if(dense.erc ne -1) then begin
		q=where(dense.time ge flattime)
		if(q[0] eq -1) then begin
			density_midflattop[i]=-10
		endif else begin
			density_midflattop[i]=dense.data[q[0]]
		endelse
	endif
	
	ip=getdata('amc_plasma current', strtrim(string(fix(shots[i])),2), /noecho)
	if(ip.erc ne -1) then begin
		q=where(ip.time ge flattime)
		if(q[0] eq -1) then begin
			ip_midflattop[i]=-10
		endif else begin
			ip_midflattop[i]=ip.data[q[0]]
		endelse
	endif
	
	nbi=getdata('anb_tot_sum_power', strtrim(string(fix(shots[i])),2), /noecho)
	if(nbi.erc ne -1) then begin
		q=where(nbi.time ge flattime)
		if(q[0] eq -1) then begin
			nbi_midflattop[i]=-10
		endif else begin
			nbi_midflattop[i]=nbi.data[q[0]]
		endelse
	endif
	
	efm=getdata('efm_plasma_energy', strtrim(string(fix(shots[i])),2),/noecho)
	if(efm.erc ne -1) then begin
		q=where(efm.time ge flattime)
		if(q[0] eq -1) then begin
			w_midflattop[i]=-10
		endif else begin
			w_midflattop[i]=efm.data[q[0]]
		endelse
	endif
	

	bn=getdata('efm_betan', strtrim(string(fix(shots[i])),2), /noecho)
	if(bn.erc ne -1) then begin
		q=where(bn.time ge flattime)
		if(q[0] eq -1) then begin
			betan_midflattop[i]=-10
		endif else begin
			betan_midflattop[i]=bn.data[q[0]]
		endelse
	endif
	
	bp=getdata('efm_betap', strtrim(string(fix(shots[i])),2), /noecho)
	if(bp.erc ne -1) then begin
		q=where(bp.time ge flattime)
		if(q[0] eq -1) then begin
			betap_midflattop[i]=-10
		endif else begin
			betap_midflattop[i]=bp.data[q[0]]
		endelse
	endif
	
	bt=getdata('efm_betat', strtrim(string(fix(shots[i])),2), /noecho)
	if(bt.erc ne -1) then begin
		q=where(bt.time ge flattime)
		if(q[0] eq -1) then begin
			betat_midflattop[i]=-10
		endif else begin
			betat_midflattop[i]=bt.data[q[0]]
		endelse
	endif
	
	btoroidal=getdata('efm_bphi_rmag', strtrim(string(fix(shots[i])),2), /noecho)
	if(btoroidal.erc ne -1) then begin
		q=where(btoroidal.time ge flattime)
		if(q[0] eq -1) then begin
			btoroidal_midflattop[i]=-10
		endif else begin
			btoroidal_midflattop[i]=btoroidal.data[q[0]]
		endelse
	endif
	
	li=getdata('efm_li', strtrim(string(fix(shots[i])),2), /noecho)
	if(li.erc ne -1) then begin
		q=where(li.time ge flattime)
		if(q[0] eq -1) then begin
			li_midflattop[i]=-10
		endif else begin
			li_midflattop[i]=li.data[q[0]]
		endelse
	endif
	
	z=getdata('efm_magnetic_axis_z', strtrim(string(fix(shots[i])),2), /noecho)
	if(z.erc ne -1) then begin
		q=where(z.time ge flattime)
		if(q[0] eq -1) then begin
			zmagaxis_midflattop[i]=-10
		endif else begin
			zmagaxis_midflattop[i]=z.data[q[0]]
		endelse
	endif
	
	
	
	endif else begin
; 		nbi_midflattop[i]=-10
; 		ip_midflattop[i]=-10
; 		density_midflattop[i]=-10
; 		drsep_midflattop[i]=-10
; 		w_midflattop[i]=-10
; 		betan_midflattop[i]=-10
; 		betap_midflattop[i]=-10
; 		betat_midflattop[i]=-10
; 		btoroidal_midflattop[i]=-10
; 		flattoptime[i]=-10
; 		li_midflattop[i]=-10
		zmagaxis_midflattop[i]=-10
		
	endelse
	
nextshot:
	
;save, filename='disruption_Efit_ITPA_plusflattop_partial.sav'
		
endfor

;save, filename='disruption_Efit_ITPA_plusflattop_final.sav'
save, filename='disruption_efit_0709_flattop.sav'

END
	
	