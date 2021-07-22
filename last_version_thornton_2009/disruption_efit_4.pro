PRO disruption_efit_4

;run after disruption_efit_3

;performs the correction to w_maximum and w_ratio due to the presence of HL transitions
;Code for this copied from wratio_hlchange.pro

;performs the CQ analysis as detailed in cq.pro. 

;restore, 'disruption_efit_11c.sav' ;re run to change the definition of 100% Ip.
;restore, 'disruption_efit_11.sav' ;rerun, as seem to have a problem with some TQ times
;restore, 'disruption_efit_9_tmp.sav'
;restore, 'disruption_efit_M7_3.sav'
restore, 'disruption_efit_0709_3.sav'


;goto, cqanalysis

;===========ammend the w_ratio values based on HL transitions===========
wmax_hl=make_array(n_elements(shots))
w_ratiohl=make_array(n_elements(shots))
;time_wmaxhl=make_array(n_elements(shots))
use_hl=make_array(n_elements(shots))

q=where(use eq 1)

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
    
    if(use[q[i]] eq 1)then begin
        w_ratiohl[q[i]]=w_disrupt[q[i]]/wmax_hl[q[i]]
    endif

    if(use[q[i]] eq 1 and w_ratiohl[q[i]] gt 0 and w_ratiohl[q[i]] le 1) then begin
        use_hl[q[i]]=1
    endif else begin
        use_hl[q[i]]=0
    endelse


next:

endfor

cqanalysis:

;===========Find the cq information==========================

upperlimit=0.8
lowerlimit=0.2

cq_time=make_array(n_elements(shots))
cq_ipdrop=make_array(n_elements(shots))
cq_rate=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin

ip=getdata('amc_plasma current', strtrim(string(fix(shots[i])),2))

    if(ttq[i] gt 5 or finite(ttq[i]) eq 0) then begin
    	cq_time[i]=-2
    	cq_ipdrop[i]=-2
    	cq_rate[i]=-2
    	goto, finish
    endif
    
    if(disrupting[i] eq 0) then begin
    	cq_time[i]=-2
    	cq_ipdrop[i]=-2
    	cq_rate[i]=-2
    	goto, finish
    endif
    
    iprange=where(ip.time ge ttq[i]-0.001)
    ip_time=ip.time[iprange]
    
    tqpoint=where(ip.time ge ttq[i])
    ;plot, ip.time[iprange], ip.data[iprange], xrange=[disruption_time[i], disruption_time[i] + 0.05], xs=1

    ;maxip=max(ip.data[iprange])
    maxip=ip.data[tqpoint[0]]
    maxpoint=where(ip.data[iprange] eq maxip)
    maxtime=ip_time[maxpoint]
    maxtime=maxtime[0]

    lowlim_ip=maxip*lowerlimit
    uplim_ip=maxip*upperlimit
    
    ;ipfall=where(ip.data lt maxip and ip.time gt maxtime)

    ;oplot, [0,5],[lowlim_ip,lowlim_ip], color=truecolor('red')
    ;oplot, [0,5],[uplim_ip,uplim_ip], color=truecolor('red')
    ;oplot, [maxtime, maxtime], [maxip,maxip], psym=7, color=truecolor('limegreen'), symsize=2

    lower_ip=where(ip.data[iprange] le lowlim_ip)
    upper_ip=where(ip.data[iprange] le uplim_ip and ip_time gt maxtime)

    if(upper_ip[0] eq -1 or lower_ip[0] eq -1) then begin
        cq_time[i]=-1
        cq_ipdrop[i]=-1
        cq_rate[i]=-1
    goto, finish
    endif
    
    ;fit a line through the datapoints around the point identified by lower_ip
    if(lower_ip[0] eq 0) then begin
    	cq_time[i]=-100
        cq_ipdrop[i]=-100
        cq_rate[i]=-100
    goto, finish
    endif
    
    xpoints=[ip.time[iprange[lower_ip[0]-1]],ip.time[iprange[lower_ip[0]]]]
    ypoints=[ip.data[iprange[lower_ip[0]-1]],ip.data[iprange[lower_ip[0]]]]
    
    fit1=linfit(xpoints, ypoints)
    lower_time=((lowlim_ip-fit1[0])/fit1[1])
    
    ;fit a line through the datapoints around the point identified by upper_ip
    xpoints2=[ip.time[iprange[upper_ip[0]-1]],ip.time[iprange[upper_ip[0]]]]
    ypoints2=[ip.data[iprange[upper_ip[0]-1]],ip.data[iprange[upper_ip[0]]]]
    
    fit2=linfit(xpoints2, ypoints2)
    upper_time=((uplim_ip-fit2[0])/fit2[1])


    ;lower_time=ip_time[lower_ip]
    ;upper_time=ip_time[upper_ip]

    ;oplot, [lower_time[0], lower_time[0]], !y.crange, color=truecolor('blue')
    ;oplot, [upper_time[0], upper_time[0]], !Y.crange, color=truecolor('blue')

    ;plots, [maxtime, maxtime], !Y.crange, color=truecolor('yellow')

    cq_time[i]=lower_time[0]-upper_time[0]
    cq_ipdrop[i]=uplim_ip-lowlim_ip
    cq_rate[i]=(cq_ipdrop[i])/(cq_time[i])

finish:

;stop

endfor

;save, filename='disruption_efit_M7_4.sav'
;save, filename='disruption_efit_11d.sav' ;now with the definition of 100% Ip changed to be the plasma current at the time of the thermal quench (ip_disruption)
;save, filename='disruption_efit_4.sav'
;save, filename='disruption_efit_9.sav'
save, filename='disruption_efit_0709_4.sav'

END

