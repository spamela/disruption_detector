PRO disruption_efit_280610_2

if(file_test('~athorn/disrupt_db/END_JUNE09/disruption_efit_280610_2.sav') eq 1)then begin
	print, 'Restoring previous save file'
	restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_280610_2.sav'
	variable=i
endif else begin
	restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_280610.sav'
	variable=0
endelse

if(exists(use_280610) eq 1) then begin
	print, 'Skipping use_280610'
endif else begin
use_280610=make_array(n_elements(shots))
q=where(use eq 1)
r=where(nbi_max lt 0.4 and isol_constant eq 1 and disruption eq 1 and use_260610 eq 1 and use eq 0 and ip_flattop_yn eq 1)

use_280610[q]=1
use_280610[r]=1
;delvar, use_260610 ;includes shots which do not have constant NBI (extra 300 or so)
use_260610=make_array(n_elements(shots))

endelse
;Determine H or L mode and last HL transition time, only need to do this for shots missed (mostly ohmic)

q=where(use_280610 eq 1 and use eq 0 and w_disrupt gt 0)
;more, q
number=n_elements(q)

;stop

for i=variable, n_elements(q)-1 do begin

	print, 'Discharge: ', strtrim(string(fix(i)),2), ' of ', number
	print, 'Shot: ', shots[q[i]]

    da=getdata('xim_da/bo6',string(fix(shots[q[i]])))

    if(da.erc eq -1)then begin
        da=getdata('xim_da/hm10/t',string(fix(shots[q[i]])))
    endif

    if(da.erc eq -1) then begin
        hmode_ever[q[i]]=-1
        hl_trans[q[i]]=-1
        goto, next
    endif  

    r=where(da.data gt 0.001)

    n_da=n_elements(r)-1

    plot, da.time[0:r[n_da]], da.data[0:r[n_da]], xrange=[0, da.time[r[n_da]]], xstyle=1, title=shots[q[i]], yrange=[0,3]

    oplot, [ttq[q[i]], ttq[q[i]]], $
           [-100, 100], color=truecolor('red')

;stop

    hm=''
    t=''

    read, hm, prompt='L or H mode, x to exit'

    if(hm eq 'h') then begin
         hmode_ever[q[i]]=1
         read, t, prompt='Time of last HL: '
         hl_trans[q[i]]=t
         goto, next
    endif

    if(hm eq 'l') then begin
        hmode_ever[q[i]]=0
    endif

    if(hm eq 'd') then begin
        hmode_ever[q[i]]=0.5
    endif

    if(hm eq 'x')then begin
        goto, saving
    endif

next:

endfor

saving:

save, filename='disruption_efit_280610_2.sav'

stop

END
