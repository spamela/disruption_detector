PRO tweakTQstages

;restore, 'disruption_efit_10a.sav'
;restore, 'disruption_efit_ITPA_goodtqadded.sav
restore, 'disruption_efit_0709_tqfix_interim.sav'

good_tq=make_array(n_elements(shots))

q=where(use_hl eq 1 and shots ne 22228)

print, i
;stop

for i=0, n_elements(q)-1 do begin

   if(shots[q[i]] eq 19533 or shots[q[i]] eq 19902 or  shots[q[i]] eq 20066) then begin
      good_tq[q[i]]=-1
      goto, nextshot
   endif

	print, strtrim(string(fix(shots[q[i]])),2)
	
	if(tq_stages[q[i]] lt -1) then begin
		good_tq[q[i]]=-5
		goto, nextshot
	endif

	tq, strtrim(string(fix(shots[q[i]])),2)
	
	read, value, Prompt='Enter good (1) no good (0)'
	
	if(value eq -10) then begin
		goto, saving
	endif
	
	good_tq[q[i]]=value
	
nextshot:
	
endfor

saving:

;save, filename='disruption_efit_10a.sav'
;save, filename='disruption_efit_tqfix.sav
save, filename='disruption_efit_0709_tqfix.sav'

END
