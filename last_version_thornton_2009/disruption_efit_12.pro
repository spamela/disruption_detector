PRO disruption_efit_12

;find the best fit to the current quench usign method set out in sugihara et al J. Plasma Fus. Res. vol79, no7, 2003, 706-712

;restore, 'disruption_efit_11e.sav'
;restore, 'disruption_efit_12.sav'
;restore, 'disruption_efit_M7_11e.sav'
restore, 'disruption_efit_0709_11.sav'

rmse_lin=make_array(n_elements(shots))
rmse_exp=make_array(n_elements(shots))
cq_ratemax=make_array(n_elements(shots))
chisq_exp=make_array(n_elements(shots))
status_exp=make_array(n_elements(shots))
zmagaxis=make_array(n_elements(shots))
sxr_l1ttq=make_array(n_elements(shots))
ttq_ok=make_array(n_elements(shots))
use_tq=make_array(n_elements(shots))

q=where(use_hl eq 1)

for i=0, n_elements(q)-1 do begin
	
	result=ipfit_mod(strtrim(string(fix(shots[q[i]])),2))
	
	rmse_lin[q[i]]=result.linearrmse
	rmse_exp[q[i]]=result.exprmse
	cq_ratemax[q[i]]=result.maximumcqrate
	chisq_exp[q[i]]=result.chisq_exp
	status_exp[q[i]]=result.statusexp
	
	efm=getdata('efm_magnetic_axis_z', strtrim(string(fix(shots[q[i]])),2))
	
	findtime=where(efm.time gt (ttq(strtrim(string(fix(shots[q[i]])),2))-0.025))
	
	zmagaxis[q[i]]=efm.data[findtime[0]]
	
	sxr=getdata('xsx_hcaml#1', strtrim(string(fix(shots[q[i]])),2))
	
	if(sxr.erc eq -1) then begin
		sxr_l1ttq[q[i]]=-10
	endif else begin
		findsxr=where(sxr.time ge ttq(strtrim(string(fix(shots[q[i]])),2)))
		;athorn mod 27/04/09, fiddle with it till it works...
		if(findsxr[0] eq -1) then begin
			ttq_ok[q[i]]=-10
			use_tq[q[i]]=-10
			goto, nextshot
		endif
		
		sxr_l1ttq[q[i]]=sxr.data[findsxr[0]]
		;end athorn mod
		
	endelse
	
	;check that the found TQ is not the first of a series of decreases, eliminate if it is (like in 17527 for example)
	ttq_ok[q[i]]=ttq_check(strtrim(string(fix(shots[q[i]])),2))
	
	if(use_hl[q[i]] eq 1 and ttq_ok[q[i]] eq 1) then begin
		use_tq[q[i]] = 1
	endif else begin
		use_tq[q[i]] = 0
	endelse
	
nextshot:
	
endfor

;save, filename='disruption_efit_12b.sav'
;save, filename='disruption_efit_M7_12.sav'
save, filename='disruption_efit_0709_12.sav'

END
