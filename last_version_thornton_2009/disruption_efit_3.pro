PRO disruption_efit_3

;next program to run after disruption_efit_2
;finds the h mode shots
;copies in the previously obtained values for hmode and hl_trans
;from hmode_data.sav (which came from disrupt_db3500to19000v21.sav,
;variables hm_ever and hl_last)

;restore, 'disruption_efit_2.sav'
;restore, 'disruption_efit_M7_3_partial.sav'
;restore, 'hmode_data.sav' ;contains hmode_ever (was called hm_ever) and hl_trans (was hl_last, which is the time of the last hl transition).
restore, 'disruption_efit_0709_2.sav'

;add these for m7_2.sav
hmode_ever=make_array(n_elements(shots))
hl_trans=make_array(n_elements(shots))

;q=where(use eq 1 and hmode_ever eq 0)
q=where(use eq 1) ;for m7_2 data
more, q

for i=0, n_elements(q)-1 do begin

	print, shots[q[i]]

    da=getdata('xim_da/bo6',string(fix(shots[q[i]])))

    if(da.erc eq -1)then begin
        da=getdata('xim_da/bo10',string(fix(shots[q[i]])))
    endif

    if(da.erc eq -1) then begin
        hmode_ever[q[i]]=-1
        hl_trans[q[i]]=-1
        goto, next
    endif  

    r=where(da.data gt 0.001)

    n_da=n_elements(r)-1

    plot, da.time[0:r[n_da]], da.data[0:r[n_da]], xrange=[0, da.time[r[n_da]]], xstyle=1, title=shots[q[i]], yrange=[0,1]

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

save, filename='disruption_efit_0709_3.sav'

END