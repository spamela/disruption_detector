PRO disruption_efit_11

;restore, 'disruption_efit_10c.sav'
;restore, 'disruption_efit_M7_10.sav'
restore, 'disruption_efit_0709_10.sav'

use_hl_old=use_hl
isol_change_v11=make_array(n_elements(shots))

q=where(use_hl_old eq 1)
more, q

;some shots have flat regions in the Isol trace that occur before the disruption, need to make some changes.
for i=0, (n_elements(where(use_hl_old eq 1))-1) do begin

;for i=0, (n_elements(use_hl_old eq 1)-1) do begin ;- used to say this above, but kept subscripting with i>q

isol=getdata('amc_sol current', strtrim(string(fix(shots[q[i]]))))

plot, isol.time, isol.data, xrange=[0,0.6]
max_isol_time=max(isol.time)
isol_deriv=smooth(deriv(isol.time, isol.data),10)
isol_change_pt = where(isol_deriv GT 50 and isol.time GT 0.1)
isol_change_v11[q[i]]=isol.time[isol_change_pt[0]]

if(isol_change_v11[q[i]] lt ttq[q[i]]) then begin
	use_hl[q[i]]=0
endif else begin
	use_hl[q[i]]=1
endelse

endfor

good=where(use_hl eq 1)
more, good

save, filename='disruption_efit_M7_11.sav'
save, filename='disruption_efit_0709_11.sav'

END