PRO disruption_efit_2

;run this program after disruption_efit.pro to set the flags
;disrupting, use, etc.

restore, 'disruption_efit.sav'

;make necessary arrays
disrupting=make_array(n_elements(shots))
nbi_constant=make_array(n_elements(shots))
isol_constant=make_array(n_elements(shots))
ip_flattop_yn=make_array(n_elements(shots))
use=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin

    if(ip_end_time[i] ne  ttq[i] and shots[i] ne 0 and ip_disruption[i] ne -1) then begin
     disrupting[i]=1
    endif

    if(ip_end_time[i] eq ttq[i]) then begin
     disrupting[i]=0
    endif

    ip=getdata('amc_plasma current',strtrim(string(fix(shots[i])),2))

    disrupt_point=where(ip.time gt ttq[i])

    if(disrupt_point[0] eq -1) then begin
          ip_flattop_yn[i]=-1
          goto, end_of_ip
    endif

    if(disrupt_point[0] lt 41) then begin
        ip_flattop_yn[i]=-1
        goto, last
    endif

    if((ip.data[disrupt_point[0]-40] lt (ip.data[disrupt_point[0]-10]*0.9) or $
        (ip.data[disrupt_point[0]-40] gt ip.data[disrupt_point[0]-10]*1.1))) then begin
        ip_flattop_yn[i]=0
        goto,last
    endif

    ip_flattop_yn[i]=1

last:
end_of_ip:

;constant NBI and ISOL checks

    if(nbi_cease[i] gt ttq[i]) then begin
        nbi_constant[i]=1
    endif

    if(isol_change[i] gt ttq[i] or isol_change[i] eq ttq[i]) then begin
        isol_constant[i]=1
    endif

    if(nbi_constant[i] eq 1 and ttq[i] eq 1 and ip_flattop_yn[i] eq 1 and isol_constant[i] eq 1) then begin
        use_shot[i]=1
    endif
    
;use this shot or not

    if(nbi_constant[i] eq 1 and isol_constant[i] eq 1 and disrupting[i] eq 1 and w_ratio[i] lt 1 and w_ratio[i] gt 0) then begin
        use[i]=1
    endif else begin
    use[i]=0
endelse
endfor

save, filename='disruption_efit_0709_2.sav'

END
