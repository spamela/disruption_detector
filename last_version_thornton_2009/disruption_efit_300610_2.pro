PRO disruption_efit_300610_2

;copy of tweaktqstages - program allows the fitting fo the TQ SXR data to be assessed.
;Code needs tq.pro to run

;================================================================

;restore, 'disruption_efit_10a.sav'
;restore, 'disruption_efit_ITPA_goodtqadded.sav
;restore, 'disruption_efit_0709_tqfix_interim.sav'
if(file_test('~/disrupt_db/END_JUNE09/disruption_efit_300610_2.sav') eq 1) then begin
	restore, '~/disrupt_db/END_JUNE09/disruption_efit_300610_2.sav'
	loopvar=i
endif else begin
	restore, '~/disrupt_db/END_JUNE09/disruption_efit_300610.sav'
	loopvar=0
endelse

q=where(use_hl eq 1 and shots ne 22228 and use eq 0)

;print, i
;stop

for i=loopvar, n_elements(q)-1 do begin

	print, 'Discharge: ', i, ' of ', strtrim(string(fix(n_elements(q))),2)

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
	
;	stop
nextshot:
	
endfor

saving:

;save, filename='disruption_efit_10a.sav'
;save, filename='disruption_efit_tqfix.sav
;save, filename='disruption_efit_0709_tqfix.sav'
save, filename='disruption_efit_300610_2.sav'



END
