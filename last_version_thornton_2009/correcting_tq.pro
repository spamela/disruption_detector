PRO correcting_tq

;this program can replace cq_filter at is looks for the same problems, I think.....

;have some discharges where the TQ is in the wrong place, or discharges where the TQ is identified but the discharge does 
;not disrupt. To solve these problems a limit can be placed on the gradient of the plasma current at the TQ point.
;Discharges where the TQ is dientified and the shot does not disrupt will have low values of the Ip graient at the TQ.

;to remove discharges where the TQ is identified as and IRE and additional constraint that the maximum dIp/dt time should be within 10ms of the minimum dIp/dt time can be applied.

;do this use the ttq program, modifiy the graident limit and add a check on the location of the min dIp/dt values, call it ttq2.pro.

;restore, 'disruption_efit_ITPA_020709.sav'
restore, 'disruption_efit_0709_12c.sav'

disruption=make_array(n_elements(shots))

for i=0, n_elements(shots) do begin
	
	time=ttq2(strtrim(string(fix(shots[i])),2))
	
	if(time.ttq eq -10) then begin
		disruption[i]=-1
	endif
	if(time.ttq eq time.ends) then begin
		disruption[i]=0
	endif
	if(time.ttq lt time.ends and time.ttq gt 0) then begin
		disruption[i]=1
	endif
endfor

;need to correct the values in use_hl, or just remember that disruption eq 1 is also required.....

save, filename='disruption_efit_0709_12d.sav'

END
