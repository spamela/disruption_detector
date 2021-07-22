PRO disruption_efit_300610

restore, '~/disrupt_db/END_JUNE09/disruption_efit_280610_2.sav'

;===========ammend the w_ratio values based on HL transitions===========
;wmax_hl=make_array(n_elements(shots))
;w_ratiohl=make_array(n_elements(shots))
;time_wmaxhl=make_array(n_elements(shots))
;use_hl=make_array(n_elements(shots))

q=where(use eq 0 and use_280610 eq 1)

for i=0, n_elements(q)-1 do begin

	if(finite(ttq[q[i]]) eq 0) then begin
		wmax_hl[q[i]]=-10
		use[q[i]]=-1
		goto, next
	endif

    check_difference=ttq[q[i]]-hl_trans[q[i]]

    if(hmode_ever[q[i]] eq 0) then begin
        wmax_hl[q[i]]=w_maximum[q[i]]
        ;time_wmaxhl[q[i]]=w_max_time[q[i]]
        ;wmax remains as the maximum during the shot
    endif

    if(hmode_ever[q[i]] eq 0.5) then begin
        wmax_hl[q[i]]=w_maximum[q[i]]
        ;time_wmaxhl[q[i]]=w_max_time[q[i]]
        ;if dithering then just use old w_max
    endif

    if(check_difference le 0.03 and hmode_ever[q[i]] eq 1) then begin
        wmax_hl[q[i]]=w_maximum[q[i]]
        ;time_wmaxhl[q[i]]=w_max_time[q[i]]
        ;wmax remains as the maximum during the shot
    endif

    if(check_difference gt 0.03 and hmode_ever[q[i]] eq 1)then begin
        w=getdata('efm_plasma_energy', string(fix(shots[q[i]])))
        find_time=hl_trans[q[i]]+0.03
        
        find=where(w.time ge find_time)

        if(find[0] eq -1)then begin
            wmax_hl[q[i]]=-2
            ;time_wmaxhl[q[i]]=-2
            w_ratiohl[q[i]]=-10
            goto, next
        endif
                       
        wmax_hl[q[i]]=w.data[find[0]]
        ;time_wmaxhl[q[i]]=w.time[find[0]]
    endif
    
    if(use_280610[q[i]] eq 1)then begin
        w_ratiohl[q[i]]=w_disrupt[q[i]]/wmax_hl[q[i]]
    endif

    if(use_280610[q[i]] eq 1 and w_ratiohl[q[i]] gt 0 and w_ratiohl[q[i]] le 1) then begin
        use_hl[q[i]]=1
    endif else begin
        use_hl[q[i]]=0
    endelse

next:

endfor

save, filename='disruption_efit_300610.sav'

END
